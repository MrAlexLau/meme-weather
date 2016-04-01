class Api::WeatherMemesController < ApplicationController
  def search
    theme = params[:theme]
    weather_status = WeatherQuery.find_or_create_by_location(params[:location])
    themed_search_term = "#{theme} #{weather_status.short_description} meme"
    image_url = ImageService.search(themed_search_term)

    render json: {
      location_name: weather_status.location_name,
      temperature: weather_status.temperature,
      temperature_unit: weather_status.temperature_unit,
      weather_conditions: weather_status.long_description,
      meme_image_link: image_url,
    }
  end
end
