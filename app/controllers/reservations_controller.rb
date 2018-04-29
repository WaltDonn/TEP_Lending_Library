require 'thread'
class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy, :picked_up, :returned, :edit_check_in]
  before_action :authenticate_user!
  @@semaphore = Mutex.new




  # GET /reservation_calendar/1
  def rental_calendar
    @reservations = Reservation.all
    authorize! :rental_calendar, @reservations
  end
  

#VOLUNTEER ACTIONS

  # GET /returns
  def volunteer_portal
    authorize! :volunteer_portal, :Reservation
  end

  # GET /returns
  def returns
    @today_return = Reservation.returning_today
    authorize! :returns, :Reservation
  end

  # GET /pickup
  def pickup
    @today_pickup = Reservation.picking_up_today
    authorize! :pickup, :Reservation
  end

  def picked_up
    authorize! :picked_up, :Reservation

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
    authorize! :returned, :Reservation

    @reservation.returned = true
    @reservation.user_check_in = params["returned_path"]["name"]

    kit = @reservation.kit
    kit.reserved = false
    

    respond_to do |format|
      if @reservation.save! && kit.save!
        format.html { redirect_to edit_check_in_path, notice: 'Reservation was successfully checked in.' }
      else
        format.html { redirect_to returns_path, notice: 'Issue checking in item.' }
      end
    end
  end

  def edit_check_in
    authorize! :edit_check_in, :Reservation

    @kit = @reservation.kit
    @items = @kit.items
  end

  def check_in_finish
    authorize! :check_in_finish, :Reservation
    # first check if all component changes are valid
    all_valid = true

    params["check_in_finish_path"].each do |comp|
      @curr_component = Component.find(comp.to_i)
      @curr_component.damaged = params["check_in_finish_path"][comp]["damaged"]
      @curr_component.missing = params["check_in_finish_path"][comp]["missing"]
      unless @curr_component.valid? 
        all_valid = false
      end
    end

    respond_to do |format|
      # if all component changes are valid, save all
      if all_valid

        all_save = true

        params["check_in_finish_path"].each do |comp|
          @curr_component = Component.find(comp.to_i)
          @curr_component.damaged = params["check_in_finish_path"][comp]["damaged"]
          @curr_component.missing = params["check_in_finish_path"][comp]["missing"]
          unless @curr_component.save!
            all_save = false
          end
        end
        if all_save
          format.html { redirect_to returns_path, notice: 'Kit checked in.' }
        else
          format.html { redirect_to edit_check_in_path, notice: 'Issue checking in kit.' }
        end
      else
        format.html { redirect_to edit_check_in_path, notice: 'Invalid input.' }
      end
    end 
  end

#RENT A KIT ACTIONS

  def choose_dates
    authorize! :choose_dates, :Reservation

    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end

    @start_date = Date.today.next_month.beginning_of_month

    # pick_up_dates is the first full week of next month starting from the first weekday
    @pick_up_start_date = @start_date
    @pick_up_start_date += 1.days until @pick_up_start_date.wday == 1 # wday 1 is monday, etc.
    @pick_up_dates = @pick_up_start_date..(@pick_up_start_date + 5.days)

    # return_dates is the last full week of next month ending on the last weekday
    @return_end_date = Date.today.next_month.end_of_month
    @return_end_date -= 1.days until @return_end_date.wday == 1 # wday 1 is monday, etc.
    @return_dates = (@return_end_date)..(@return_end_date + 5.days)
    @end_date = @return_dates.last
  end

  # POST /select_dates
  def select_dates

    authorize! :select_dates, :Reservation
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
    
    @start_date = Date.today.beginning_of_month.next_month


    @return_end_date = Date.today.next_month.end_of_month
    @return_end_date -= 1.days until @return_end_date.wday == 1 # wday 1 is monday, etc.
    @return_dates = (@return_end_date)..(@return_end_date + 5.days)
    @end_date = @return_dates.last

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
    unless params[:format].nil?
      session[:rental_category_id] = params[:format]
    end

    authorize! :confirm_user_details, current_user
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
  
    @rental_category = ItemCategory.find(session[:rental_category_id])
  end

  def edit_user_details
    if(session[:rental_category_id].nil?)
      redirect_to shopping_path
    end
    
    @rental_category = ItemCategory.find(session[:rental_category_id])
    @user = current_user

    authorize! :edit_user_details, @user
  end
  
  def submit_user_details
    @user = current_user
    authorize! :submit_user_details, @user

    if(!params[:user][:first_name].nil?)
      @user.first_name = params[:user][:first_name]
    end
    if(!params[:user][:last_name].nil?)
      @user.last_name = params[:user][:last_name]
    end
    if(!params[:user][:email].nil?)
      @user.email = params[:user][:email]
    end
    if(!params[:user][:phone_num].nil?)
      @user.phone_num = params[:user][:phone_num]
    end
    if(!params[:user][:phone_ext].nil?)
      @user.phone_ext = params[:user][:phone_ext]
    end
    if(!params[:user][:schoold_id].nil?)
      @user.school_id = params[:user][:school_id]
    end
    if(!params[:user][:class_size].nil?)
      @user.class_size = params[:user][:class_size]
    end
    respond_to do |format|
      if @user.save
          format.html { redirect_to reservation_choose_dates_path }
      else
           format.html { render :edit_user_details }
      end
    end
  end
  
  def reservation_error
  end
  




#CRUD ACTIONS

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all.paginate(:page => params[:page]).per_page(10)
    authorize! :index, :Reservations
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


  def manager_new
      @reservation = Reservation.new
      authorize! :manager_new, @reservation
  end

  def manager_create
    byebug
    @reservation = Reservation.new(reservation_params)
    @reservation.start_date = @reservation.pick_up_date
    @reservation.end_date = @reservation.return_date
    authorize! :manager_create, @reservation

    kit = @reservation.kit
    kit.reserved = true

    respond_to do |format|
      if @reservation.save && kit.save!
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
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
    authorize! :create, @reservation

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
          session[:rental_category_id] = nil
          session[:start_date] = nil
          session[:end_date] = nil
          session[:pickup_date] = nil
          session[:return_date] = nil

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
    authorize! :update, @reservation
    respond_to do |format|
       #Shouldn't accept new kit, after being returned
      if(@reservation.picked_up == true)
           @reservation.errors.add(:kit_id, "Cannot change kit after kit has been picked up")
           format.html { render :edit }
      end


      #If the kit has been changed, then we need to un-reserve the old one
      #Reserve the new one
      save_kit_id = nil

      if(params[:kit_id] != @reservation.kit_id)
        save_kit_id = @reservation.kit_id
        Kit.find(params[:kit_id]).set_reserved
        @reservation.kit.unset_reserved
      end



      if @reservation.update(reservation_params)
        if(save_kit_id != nil)
          #Kit was changed, and was saved
          Kit.find(save_kit_id).unset_reserved
        end
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        #Change not accepted, unreserve kit
        Kit.find(params[:kit_id]).unset_reserved
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    authorize! :destroy, @reservation
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to home_path, notice: 'Reservation was successfully destroyed.' }
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
