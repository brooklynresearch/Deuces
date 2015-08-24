class Admin::LockersController < ApplicationController
  before_action :admin_basic_auth
  before_action :load_locker, only: [:show, :clear, :disable]
  def index
    @occupied_count  = Locker.all_occupied.count
    @open_count      = Locker.all_open.count
    @lockers         = Locker.ordered
  end


  def show
    @locker = Locker.find(params[:id])
    @current_rental = @locker.current_rental
  end

  def clear
    if @locker.current_rental.present?
      @locker.current_rental.complete!
    else
      @locker.set_unoccupied
    end
    if @locker.save
      lrc_response = LockerRoomClient.new(@locker, params[:device_id]).ping_retrieval
      if lrc_response
        flash[:notice] = "Locker #{@locker.coordinates} has been cleared."
      else
        flash[:notice] = "Locker #{@locker.coordinates} was cleared, but we couldn't connect to the locker to open it. Please try again."
      end
    else
      flash[:notice] = "Sorry, we couldn't clear the locker, please try again"
    end
    redirect_to admin_lockers_path
  end

  def disable
    if @locker.current_rental.nil?
      @rental = @locker.rentals.create(creation_device_id: params[:device_id], last_name: "DISABLED_LOCKER",
                                       phone_number: "9999", terms: true)
      if @rental.save
        lrc_response = LockerRoomClient.new(@locker, params[:device_id]).ping_disabled
        if lrc_response
          flash[:notice] = "The locker has been disabled. End the dummy rental to re-enable it."
        else
          flash[:notice] = "The locker has been disabled, but we couldn't connect to the locker installation."
        end
      else
        flash[:notice] = "There was an issue creating a dummy rental in the database.  Please try again"
      end
    else
      flash[:notice] = "Sorry, we can't disable a currently occupied locker. Please clear the current rental first."
    end
    redirect_to admin_lockers_path
  end

  def load_locker
    @locker = Locker.find(params[:id])
  end
end
