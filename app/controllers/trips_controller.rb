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
    hoge = params[:trip][:visit_prefectures]
    if hoge
      trip.update(visit_prefectures: hoge)
    else

      trip.update(api_params)
    end
    p trip
    render json: trip
  end

  private

  def api_params
    params.require(:trip).permit(:name, :main_prefecture, :visit_prefectures)
  end


end
