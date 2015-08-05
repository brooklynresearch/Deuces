class RentalsController < ApplicationController

  before_action :select_locker_or_prevent_rental, only: :create
  before_action :set_all_lockers_full, only: [:hub, :new]

  def hub
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.locker = @selected_locker
    if @rental.save
      redirect_to rental_path(@rental)
    else
      flash[:notice] = @rental.errors.full_messages.join("; ")
      redirect_to new_rental_path
    end
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def retrieve
  end

  def complete
    @rental = Rental.where(rental_params.merge(current: true)).first
    if @rental
      @rental.complete!
      redirect_to rental_path(@rental)
    else
      flash[:notice] = "Sorry, we couldn't find a current rental with that information.  Please try again."
      redirect_to retrieve_rentals_path
    end
  end
private

  def rental_params
    params.require(:rental).permit(:phone_number, :last_name, :terms, :creation_device_id)
  end

  def select_locker_or_prevent_rental
    @selected_locker = Locker.all_open.sample
    unless @selected_locker.present?
      redirect_to new_rental_path, :notice => "Sorry, all lockers are currently occupied!"
    end
  end

  def set_all_lockers_full
    @all_lockers_full = Locker.open_count == 0
  end
end
