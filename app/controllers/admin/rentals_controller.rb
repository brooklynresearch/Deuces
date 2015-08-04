class Admin::RentalsController < ApplicationController

  def show
    @rental = Rental.find(params[:id])
  end

  def retrieve
    @rental = Rental.find(params[:id])
    @rental.complete!

    redirect_to rental_path(@rental)
  end

  def search

  end
end
