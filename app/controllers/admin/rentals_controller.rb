class Admin::RentalsController < ApplicationController

  def show
    @rental = Rental.find(params[:id])
  end

  def retrieve
    @rental = Rental.find(params[:id])
    @rental.complete!(params[:device_id])
    InstallationClient.new(@rental, creation_device_id).ping_retrieval

    redirect_to rental_path(@rental)
  end

  def search
  end

  def find
    @rental = Rental.where(current: true,
                           last_name: params["last_name"],
                           phone_number: params["phone_number"]).first
    if @rental
      redirect_to admin_rental_path(@rental)
    else
      flash[:notice] = "Sorry, we couldn't find a current rental with that information.  Please try again."
      redirect_to search_admin_rentals_path
    end
  end
end
