class Admin::LockersController < ApplicationController
  before_action :admin_basic_auth

  def index
    @occupied_count  = Locker.all_occupied.count
    @open_count      = Locker.all_open.count
    @lockers         = Locker.ordered
  end


  def show
    @locker = Locker.find(params[:id])
    @current_rental = @locker.current_rental
  end
end
