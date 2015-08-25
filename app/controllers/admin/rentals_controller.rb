class Admin::RentalsController < ApplicationController
  before_action :admin_basic_auth

  def show
    set_name_and_phone_search
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
    set_name_and_phone_search
  end

  def confirm
    @rental = Rental.find(params[:id])
  end

  def find
    unless params["last_name"].present? || params["phone_number"].present?
        flash[:notice] = "Please Provide a last name or phone number to search"
        redirect_to search_admin_rentals_path
    end
    @rentals = Rental.find_all_current(params["last_name"], params["phone_number"])

    if @rentals.length == 1
      redirect_to admin_rental_path(@rentals.first, search: "t", last_name: params["last_name"], phone_number: params["phone_number"] )
    elsif @rentals.length > 1
      redirect_to results_admin_rentals_path(rental_ids: @rentals.map(&:id), last_name: params["last_name"], phone_number: params["phone_number"] )
    else
      flash[:notice] = "Sorry, we couldn't find a current rental with that information.  Please try again."
      redirect_to search_admin_rentals_path
    end
  end

  def results
    set_name_and_phone_search
    @rentals = Rental.find(params["rental_ids"])
  end


  def set_name_and_phone_search
    @last_name = params["last_name"] || ""
    @phone_number = params["phone_number"] || ""

  end
end
