class DashboardController < ApplicationController
    before_action :authenticate_user!
  
  def dashboard
    @kits_rented = Reservation.kit_history
    @top_kits = Kit.top_kits
    @reservations = Reservation.open_reservations
    @school_rentals = Reservation.school_rental_hist
    @teacher_rentals = Reservation.teacher_rental_hist
    @employees = User.active.employees
    @damaged_kits = Kit.damaged

    authorize! :dashboard, :Dashboard
  end

  def clean_database
  end

  def destroy_database
    @Teachers = User.teachers
    @Schools = School.all
    @Reservations = Reservation.all


    @Teachers.each do |t|
        t.delete
    end

    @Schools.each do |t|
        t.delete
    end

    @Reservations.each do |t|
        t.delete
    end

    respond_to do |format|
        format.html { redirect_to dashboard_path}
    end

  end
  
end