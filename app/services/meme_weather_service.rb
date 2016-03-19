class MemeWeatherService
  def initialize(location)
    @location = location
  end

  def fetch_details
    weather_details = WeatherService.current_weather(@location)
    image_url = ImageService.search(weather_details[:short_description])

    return {
      location_name: weather_details[:location_name],
      temperature: weather_details[:temperature],
      temperature_unit: weather_details[:temperature_unit],
      weather_conditions: weather_details[:long_description],
      meme_image_link: image_url,
    }
  end
end
