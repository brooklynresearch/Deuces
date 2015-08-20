class Admin::RentalsController < ApplicationController
  before_action :admin_basic_auth

  def show
    @rental = Rental.find(params[:id])
  end

  def retrieve
    @rental = Rental.find(params[:id])
    @rental.complete!
    lrc_response = LockerRoomClient.new(@rental.locker, params[:device_id]).ping_retrieval
    if lrc_response
      redirect_to confirm_admin_rental_path(@rental)
    else
      @rental.reverse_completion!
      flash[:notice] = "There was an issue connecting with the locker.  Please Try again or ask a representative"
      redirect_to admin_rental_path(@rental)
    end
  end

  def search
  end

  def find
    @rental = Rental.find_current(params["last_name"], params["phone_number"])

    if @rental
      redirect_to admin_rental_path(@rental)
    else
      flash[:notice] = "Sorry, we couldn't find a current rental with that information.  Please try again."
      redirect_to search_admin_rentals_path
    end
  end
end
