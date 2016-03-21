class MemeWeatherService

  class << self
    def fetch_details(location, theme)
      weather_info = get_weather(location)
      image_url = ImageService.search("#{theme} #{weather_info.short_description} meme")

      return {
        location_name: weather_info.location_name,
        temperature: weather_info.temperature,
        temperature_unit: weather_info.temperature_unit,
        weather_conditions: weather_info.long_description,
        meme_image_link: image_url,
      }
    end

    private

    def get_weather(location)
      time_threshold = Time.zone.now - 1.hour
      current_weather = WeatherInfo.updated_after(time_threshold).tagged_with(location).first

      # Only call weather_from_service if no existing record is found.
      current_weather ||= weather_from_service(location)
    end

    def weather_from_service(location)
      time_threshold = Time.zone.now - 1.hour

      current_weather = WeatherService.current_weather(location)

      # TODO: consider making this a background job

      # After the service normalizes the location name,
      # check to see if any other records already match this location.
      weather_info = WeatherInfo.updated_after(time_threshold).where(location_name: current_weather[:location_name]).first

      # If no record is found, create a new one.
      unless weather_info
        weather_info = WeatherInfo.new({
          location_name: current_weather[:location_name],
          temperature: current_weather[:temperature],
          temperature_unit: current_weather[:temperature_unit],
          long_description: current_weather[:long_description],
          short_description: current_weather[:short_description],
          last_updated_at: Time.zone.now
        })
      end

      # Add the given location to the tags for the weather record.
      weather_info.location_list.add(location)
      weather_info.save

      weather_info
    end

  end
end
