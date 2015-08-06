class TestingsController < ApplicationController
  protect_from_forgery
  skip_before_filter :validate_device_id
  skip_before_filter :basic_auth

  def good
    render :json => { }, :status => 200
  end

  def bad
    render :json => { }, :status => 400
  end
end
