class Api::WeatherMemesController < ApplicationController
  def search
    weather_details = MemeWeatherPresenter.fetch_details(params[:location], params[:theme])
    render json: weather_details
  end
end
