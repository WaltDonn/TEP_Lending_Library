class DashboardController < ApplicationController

  def dashboard
    @kits_rented = Reservation.kit_history
    @top_kits = Kit.top_kits
    @reservations = Reservation.open_reservations
    @school_rentals = Reservation.school_rental_hist
    @teacher_rentals = Reservation.teacher_rental_hist
    @employees = User.active.employees
    @damaged_kits = Kit.damaged
  end
  
end