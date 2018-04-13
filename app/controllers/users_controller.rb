class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :rental_calendar, :reservation_user_edit, :rental_history]
  before_action :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    @role = params[:role]
    case params[:role]
      when 'teacher'
        @users = User.teachers
        @title = 'TEACHERS'
      when 'employee'
        @users = User.employees
        @title = 'EMPLOYEES'
      else
         @users = User.all
         @title = 'USERS'
    end
    authorize! :index, @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize! :show, @user
    @reservations = Reservation.select{|res| res.teacher_id == @user.id}
  end

  # GET /users/1/edit
  def edit
    authorize! :edit, @user
  end


  # GET /users/1/rental_history
  def rental_history
    @reservations = Reservation.select{|res| res.teacher_id == @user.id}
    authorize! :rental_history, @user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user
    respond_to do |format|
      @redir = params[:redir]
      if @user.update(user_params)
        if params[:redir].blank?
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          @item_category = ItemCategory.find(params[:item_category])
          format.html { redirect_to new_reservation_path(:item_category => @item_category.id, :step => 1) }
        end

      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :phone_num, :phone_ext, :class_size, :school_id, :is_active, :role)
    end
end
