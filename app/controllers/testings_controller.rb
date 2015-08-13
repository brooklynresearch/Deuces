class TestingsController < ApplicationController
  protect_from_forgery
  skip_before_filter :validate_device_id

  def good
    render :json => { }, :status => 200
  end

  def bad
    render :json => { }, :status => 400
  end
end
