class RentalsController < ApplicationController

  before_action :select_locker_or_prevent_rental, only: :create
  before_action :set_all_lockers_full, only: [:new]

  def hub
  end

  def size
  end

  def new
    @rental = Rental.new
    @tablet = params[:tablet].present?
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.locker = @selected_locker
    if @rental.save
      lrc_response = LockerRoomClient.new(@rental, params[:device_id]).ping_drop_off
      if lrc_response
        redirect_to rental_path(@rental)
      else
        @rental.reverse_creation!
        flash[:notice] = "There was an issue connecting with the locker.  Please Try again or ask a representative"
        redirect_to new_rental_path
      end
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
      lrc_response = LockerRoomClient.new(@rental, params).ping_retrieval
      if lrc_response
        redirect_to rental_path(@rental)
      else
        @rental.reverse_completion!
        flash[:notice] = "There was an issue connecting with the locker.  Please Try again or ask a representative"
        redirect_to new_rental_path
      end
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
    if params[:rental][:large] == "true"
      @selected_locker = Locker.large_open.sample
    else
      @selected_locker = Locker.small_open.sample
    end

    unless @selected_locker.present?
      redirect_to new_rental_path, :notice => "Sorry, all lockers are currently occupied!"
    end
  end

  def set_all_lockers_full
    if params["tablet"].present?
      @all_lockers_full = Locker.large_open.none?
    else
      @all_lockers_full = Locker.small_open.none?
    end
  end
end
