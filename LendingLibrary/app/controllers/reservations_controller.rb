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

  # GET /returns
  def returns
     @today_return = Reservation.returning_today
  end

  # GET /pickup
  def pickup
     @today_pickup = Reservation.picking_up_today
  end


  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    # forward param for item
    @item = Item.find(params[:item])
    # get available kits for this particular item
    @kits = Kit.available_kits
    # generate a random kit based on available kits
    offset = rand(@kits.count)
    puts "kits size: " + @kits.count.to_s
    @kit = @kits.at(offset)

    @reservation.kit_id = @kit.id

    # FIXME: when current_user is available
    # current_user = current_user
    # puts "current_user id: " + current_user.id.to_s # this is nil
    @current_user = User.find(3)
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
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
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
      params.require(:reservation).permit(:start_date, :end_date, :pick_up_date, :return_date, :returned, :picked_up, :release_form_id, :kit_id, :teacher_id, :user_check_in_id, :user_check_out_id)
    end
end
