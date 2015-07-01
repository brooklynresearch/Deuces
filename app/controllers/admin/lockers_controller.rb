class Admin::LockersController < ApplicationController

  def index
    @occupied_count  = Locker.all_occupied.count
    @open_count      = Locker.all_open.count
    @lockers         = Locker.ordered
  end


  def retrieve
    @locker = Locker.find(params[:id])
    rental = @locker.current_rental
    rental.complete!

    redirect_to rental_path(rental)
  end


  def show
    @locker = Locker.find(params[:id])
    @current_rental = @locker.current_rental
  end
end
