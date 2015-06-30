class RentalsController < ApplicationController

  before_action :select_locker_or_prevent_rental, only: :create

  def hub
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.create(rental_params.merge(locker_id: @selected_locker.id))
    if @rental.save
      redirect_to rental_path(@rental)
    else
      render 'new'
    end
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def retreive
  end

  def complete
    @rental = Rental.where(rental_params.merge(current: true)).first
    if @rental
      @rental.complete!
      redirect_to rental_path(@rental)
    else
      flash[:notice] = "Sorry, we couldn't find a rental with that information.  Please try again."
      render 'retreive'
    end
  end
private

  def rental_params
    params.require(:rental).permit(:pin, :last_name)
  end

  def select_locker_or_prevent_rental
    @selected_locker = Locker.all_open.sample
    unless @selected_locker.present?
      flash[:notice] = "Sorry, all lockers are currently occupied!"
      @rental = Rental.new
      render 'new'
    end
  end

end
