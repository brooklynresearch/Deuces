class TestingsController < ApplicationController
  protect_from_forgery

  def good
    render :json => { }, :status => 200
  end

  def bad
    render :json => { }, :status => 400
  end
end
