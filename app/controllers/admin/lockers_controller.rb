class Admin::LockersController < ApplicationController
  before_action :admin_basic_auth
  before_action :load_locker, only: [:show, :clear]
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


  def load_locker
    @locker = Locker.find(params[:id])
  end
end
