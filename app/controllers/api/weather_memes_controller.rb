class Api::WeatherMemesController < ApplicationController
  def search
    theme = params[:theme]
    weather_status = WeatherQuery.find_or_create_by_location(params[:location])
    themed_search_terms = [theme, weather_status.short_description, "meme"]
    meme = MemeQuery.find_or_create_by_tags(themed_search_terms)

    render json: {
      location_name: weather_status.location_name,
      temperature: weather_status.temperature,
      temperature_unit: weather_status.temperature_unit,
      weather_conditions: weather_status.long_description,
      meme_image_link: meme.image_url,
    }
  end
end
