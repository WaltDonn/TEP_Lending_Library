class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  # FIXME: temporarilly disabled for views editing
  # before_action :authenticate_user!

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end


  # GET /reservation_calendar/1
  def rental_calendar
    @reservations = Reservation.get_month(params[:month])
    @today_pickup = Reservation.picking_up_today
    @today_return = Reservation.returning_today
  end

  def rental_dates
    @reservation = params[:reservation]
  end

  # GET /returns
  def returns
     @today_return = Reservation.returning_today
  end

  # GET /pickup
  def pickup
     @today_pickup = Reservation.picking_up_today
  end

  # POST /select_dates
  def select_dates
    @item_category = ItemCategory.find(params[:item_category])
    # FIXME: hypothetical date restriction
    @start_date = Date.today.beginning_of_month.next_month
    @end_date = Date.today.end_of_month.next_month

    @pick_up_date = (params[:reservation_select_dates][:pick_up_date]).to_date
    @return_date = (params[:reservation_select_dates][:return_date]).to_date


    if @pick_up_date.nil?
      redirect_to new_reservation_path(:step => 2, :item_category => @item_category), notice: 'Pick up date cannot be null.'
    elsif @return_date.nil?
      redirect_to new_reservation_path(:step => 2, :item_category => @item_category), notice: 'Return date cannot be null.'
    elsif @pick_up_date < @start_date
      redirect_to new_reservation_path(:step => 2, :item_category => @item_category), notice: 'Pick up date must be after start date.'
    elsif @return_date < @pick_up_date
      redirect_to new_reservation_path(:step => 2, :item_category => @item_category), notice: 'Return date must be after pick update.'
    else
      redirect_to new_reservation_path(:step => 3, :pick_up_date => @pick_up_date, :return_date => @return_date, :item_category => @item_category)
    end

  end


  # GET /reservations/1
  # GET /reservations/1.json
  def show
    # FIXME current user
    @user = User.find(7)
    @reservations = Reservation.select{|res| res.teacher_id == @user.id}
  end

  # GET /reservations/new
  def new
    @step = params[:step]

    # FIXME current user
    @user = User.find(7)
    @reservation = Reservation.new

    # params.each do |key, value|
    #   "#{key}: #{value}"
    # end

    unless @step.nil?
      @item_category = ItemCategory.find(params[:item_category])
      # sample a random item of the picked item category
      @item = @item_category.items.sample(1).first
      # get available kits for this particular item
      @kits = Kit.available_kits
      # generate a random kit based on available kits
      offset2 = rand(@kits.count)
      @kit = @kits.at(offset2)

      @reservation.kit_id = @kit.id
      @reservation.teacher_id = @user.id
    end

    unless params['pick_up_date'].nil? || params['return_date'].nil?
      # FIXME release form id
      # @reservation.release_form_id = 1
      # FIXME: hypothetical date restriction
      @reservation.start_date = Date.today.beginning_of_month.next_month
      @reservation.end_date = Date.today.end_of_month.next_month
      @reservation.pick_up_date = params['pick_up_date']
      @reservation.return_date = params['return_date']
    end

  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Thank you for supporting the STEAM Kit rental program.' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
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
