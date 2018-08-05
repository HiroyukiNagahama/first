class TripsController < ApplicationController

  def index

  end

  def load_index
    @trips = Trip.all.order(:start_date)
    render json: @trips
  end

  def create

  end

  def update
    trip = Trip.find_by(id: params[:id])
    trip.update(name_params)
    render json: trip
  end

  private

  def name_params
    params.require('trip').permit(:name, :main_prefecture)
  end


end
