class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :validate_device_id

  def validate_device_id
    unless ["0","1","2"].include?(params["device_id"])
       redirect_to root_path
    else
      @device_id = params["device_id"]
    end
  end

  def url_options
    { :device_id => @device_id }.merge(super)
  end

end
