class MemeWeatherPresenter

  class << self
    def fetch_details(location, theme)
      weather_info = WeatherQuery.find_by_location(location)
      themed_search_term = "#{theme} #{weather_info.short_description} meme"
      image_url = ImageService.search(themed_search_term)

      return {
        location_name: weather_info.location_name,
        temperature: weather_info.temperature,
        temperature_unit: weather_info.temperature_unit,
        weather_conditions: weather_info.long_description,
        meme_image_link: image_url,
      }
    end
  end

end
