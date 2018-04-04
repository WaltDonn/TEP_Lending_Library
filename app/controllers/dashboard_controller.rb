class DashboardController < ApplicationController

  def dashboard
    @kits = Kit.available_kits
    @top_kits = Kit.joins(:reservations).group("kits.id").order("count(kits.id) DESC").limit(5)
    @reservations = Reservation.open_reservations
    @schools = School.active
    @teachers = User.active.teachers
    @employees = User.active.employees
    @damaged_kits = Kit.damaged
  end
  
end