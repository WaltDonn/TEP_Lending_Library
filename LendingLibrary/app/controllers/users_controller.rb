class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :rental_calendar]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  # def new
  #   @user = User.new
  # end

  # GET /users/1/edit
  def edit
  end

  # GET /users/1/rental_calendar
  def rental_calendar
      @reservations = Reservation.get_month(params[:month]).select{|res| res.teacher_id == @user.id}
  end

  def confirmation
    @user = User.find(params[:id])
    @item_category = ItemCategory.find(params[:item_category])
    # puts "======== confirmation item category: " + @item_category.to_s
    # @reservation = :reservation
  end

  def reservation_user_edit
    @user = User.find(params[:id])
    # forward item and reservation
    @item_category = ItemCategory.find(params[:item_category])
    puts "============ic: " + @item_category.to_s
    # @reservation = :reservation
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      @redir = params[:redir]
      puts "=================== redirect_to: " + @redir
      if @user.update(user_params)
        if params[:redir].blank?
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          @item_category = ItemCategory.find(params[:item_category])

          puts "=================== @item_category id: " + @item_category.id.to_s
          format.html { redirect_to new_reservation_path(:item_category => @item_category.id, :step => 1) }
        end

      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :phone_num, :class_size, :school_id, :is_active, :role)
    end
end
