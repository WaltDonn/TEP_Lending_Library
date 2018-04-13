require 'thread'
class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy, :picked_up, :returned]
  before_action :authenticate_user!
  @@semaphore = Mutex.new

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
    authorize! :index, @reservations
  end


  # GET /reservation_calendar/1
  def rental_calendar
    @reservations = Reservation.all
    authorize! :index, @reservations
  end

  def month_calendar_td_options
    ->(start_date, current_calendar_date) {
      {class: "calendar-date", data: {day: current_calendar_date}}
    }
  end

  def rental_dates
    @reservation = params[:reservation]
  end
  
  # GET /returns
  def volunteer_portal
  end

  # GET /returns
  def returns
    @today_return = Reservation.returning_today
  end

  # GET /pickup
  def pickup
    @today_pickup = Reservation.picking_up_today
  end
  
  def choose_dates
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end

    @start_date = Date.today.next_month.beginning_of_month
    @end_date = Date.today.next_month.end_of_month

    # pick_up_dates is the first full week of next month starting from the first weekday
    @pick_up_start_date = @start_date
    @pick_up_start_date += 1.days until @pick_up_start_date.wday == 1 # wday 1 is monday, etc.
    @pick_up_dates = @pick_up_start_date..(@pick_up_start_date + 5.days)

    # return_dates is the last full week of next month ending on the last weekday
    @return_end_date = @end_date
    @return_end_date -= 1.days until @return_end_date.wday == 5 # wday 1 is monday, etc.
    @return_dates = (@return_end_date - 5.days)..@return_end_date


  end

  def picked_up

    authorize! :picked_up, @reservations

    @reservation.picked_up = true
    @reservation.user_check_out = params["picked_up_path"]["name"]
    @reservation.release_form_id = params["picked_up_path"]["form_id"]
    
    

    respond_to do |format|
      if @reservation.save!
        format.html { redirect_to pickup_path, notice: 'Reservation was successfully checked out.' }
      else
        format.html { redirect_to pickup_path, notice: 'Issue checking out item.' }
      end
    end
  end

  def returned
    authorize! :returned, @reservations

    @reservation.returned = true
    @reservation.user_check_in = params["returned_path"]["name"]

    @kit = @reservation.kit
    @kit.reserved = false
    @kit.save!

    respond_to do |format|
      if @reservation.save!
        format.html { redirect_to returns_path, notice: 'Reservation was successfully checked in.' }
      else
        format.html { redirect_to returns_path, notice: 'Issue checking in item.' }
      end
    end
  end

  # POST /select_dates
  def select_dates
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
    
    @start_date = Date.today.beginning_of_month.next_month
    @end_date = Date.today.end_of_month.next_month

    @pickup_date = (params[:reservation_select_dates][:pick_up_date]).to_date
    @return_date = (params[:reservation_select_dates][:return_date]).to_date
    


    respond_to do |format|
      if @pickup_date.nil? || @return_date.nil? 
          format.html { render :choose_dates }
      else
          if @pickup_date < @start_date || @pickup_date > @end_date
              flash.now[:error] = "Needs to be a valid pickup date"
              format.html { render :choose_dates }
          elsif @return_date < @start_date || @return_date > @end_date || @return_date < @pickup_date
               flash.now[:error] = "Needs to be a valid return date"
              format.html { render :choose_dates }
          else
            #Valid date
            session[:start_date] = @start_date
            session[:end_date] = @end_date
            session[:pickup_date] = @pickup_date
            session[:return_date] = @return_date
            format.html { redirect_to new_reservation_path }
          end
      end
    end
  end

  
  def confirm_user_details
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
  
    @rental_category = ItemCategory.find(session[:rental_category_id])
    authorize! :confirm_user_details, nil
  end
  
  def edit_user_details
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
    
    @rental_category = ItemCategory.find(session[:rental_category_id])
    @user = current_user
    authorize! :edit_user_details, nil
  end
  
  def submit_user_details
    @user = current_user
    if(!params[:user][:first_name].nil?)
      @user.first_name = params[:user][:first_name]
    end
    
    if(!params[:user][:last_name].nil?)
      @user.last_name = params[:user][:last_name]
    end
    if(!params[:user][:email].nil?)
      @user.email = params[:user][:email]
    end
    if(!params[:user][:schoold_id].nil?)
      @user.school_id = params[:user][:school_id]
    end
    if(!params[:user][:class_size].nil?)
      @user.class_size = params[:user][:class_size]
    end
    respond_to do |format|
      if @user.save!
          format.html { redirect_to reservation_choose_dates_path }
      else
           format.html { render :edit_user_details }
      end
    end
  end
  
  def reservation_error
  end
  
  
  # GET /reservations/1
  # GET /reservations/1.json
  def show
    authorize! :show, @reservation
    @user = current_user
    @reservations = Reservation.select{|res| res.teacher_id == @user.id}
  end


  # GET /reservations/new
  def new
    @reservation = Reservation.new
    authorize! :new, @reservation
    
    if(session[:rental_category_id].nil? || session[:pickup_date].nil? ||
      session[:return_date].nil? || session[:start_date].nil? || session[:end_date].nil?)
      redirect_to shopping_path
    end

    @rental_category = ItemCategory.find(session[:rental_category_id])
    @reservation.start_date = session[:start_date]
    @reservation.end_date = session[:end_date]
    @reservation.pick_up_date = session[:pickup_date]
    @reservation.return_date = session[:return_date]
  end

  # GET /reservations/1/edit
  def edit
    authorize! :edit, @reservation
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.teacher_id = current_user.id
    
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
    
   
    reservation_category = ItemCategory.find(session[:rental_category_id])
    #Nasty race condition if multiple ppl grab same kit
    @@semaphore.synchronize {
      kit_pool = Kit.available_for_item_category(reservation_category)
  
      test_kit = kit_pool.sample
      if(!test_kit.nil?)
          test_kit.set_reserved
          test_kit.reload
          @reservation.kit_id = test_kit.id
      end
      
      respond_to do |format|
        if @reservation.save
          format.html { redirect_to rental_history_path(current_user), notice: 'Thank you for supporting the STEAM Kit rental program.' }
        else
          if(!test_kit.nil?)
             test_kit.unset_reserved
             test_kit.reload
          end
          format.html { redirect_to  reservation_error_path }
        end
      end
    }
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    authorize! :update, @reservations
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date, :pick_up_date, :return_date, :returned, :picked_up, :release_form_id, :kit_id, :teacher_id, :user_check_in, :user_check_out)
    end
end
