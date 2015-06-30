class RentalsController < ApplicationController

  def hub
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.create(rental_params)
    @rental.assign_locker!
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
      @message = "Sorry, we couldn't find a rental with that information.  Please try again."
      render 'retreive'
    end
  end
private

  def rental_params
    params.require(:rental).permit(:pin, :last_name)
  end
end
