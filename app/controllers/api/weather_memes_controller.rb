class Api::WeatherMemesController < ApplicationController
  def search
    memed_weather = MemeWeatherService.new(params[:location])
    render json: memed_weather.fetch_details(params[:theme])
  end
end
