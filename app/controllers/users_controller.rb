class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :rental_calendar, :reservation_user_edit, :rental_history]
  before_action :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    @role = params[:role]
    case params[:role]
      when 'teacher'
        @users = User.teachers.paginate(:page => params[:page]).per_page(10)
        @title = 'TEACHERS'
      when 'employee'
        @users = User.employees.paginate(:page => params[:page]).per_page(10)
        @title = 'EMPLOYEES'
      else
         @users = User.all.paginate(:page => params[:page]).per_page(10)
         @title = 'USERS'
    end
    authorize! :index, :Users
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
    @email_flag = false
    
    if(!params[:user][:first_name].nil?)
      @user.first_name = params[:user][:first_name]
    end
    if(!params[:user][:last_name].nil?)
      @user.last_name = params[:user][:last_name]
    end
    if(!params[:user][:email].nil?)
      @user.email = params[:user][:email]
      @email_flag = true
    end

    if(!params[:user][:password].nil? && params[:user][:password] != "")
      @user.password = params[:user][:password]
    end
     if(!params[:user][:password_confirmation].nil? && params[:user][:password_confirmation] != "")
      @user.password_confirmation = params[:user][:password_confirmation]
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
        if @email_flag
          format.html { redirect_to user_path(@user), alert: "You will need to confirm your new email address before changes take place"}
        else
          format.html { redirect_to user_path(@user)}
        end
      else
           format.html { render :edit}
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
