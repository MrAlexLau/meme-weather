class MemeWeatherPresenter

  class << self
    def fetch_details(location, theme)
      weather_status = WeatherQuery.find_by_location(location)
      themed_search_term = "#{theme} #{weather_status.short_description} meme"
      image_url = ImageService.search(themed_search_term)

      return {
        location_name: weather_status.location_name,
        temperature: weather_status.temperature,
        temperature_unit: weather_status.temperature_unit,
        weather_conditions: weather_status.long_description,
        meme_image_link: image_url,
      }
    end
  end

end
