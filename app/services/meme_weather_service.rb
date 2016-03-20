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

      weather_details = WeatherService.current_weather(location)

      # TODO: consider making this a background job

      # After the service normalizes the location name,
      # check to see if any other records already match this location.
      wi = WeatherInfo.updated_after(time_threshold).where(location_name: weather_details[:location_name]).first

      # If no record is found, create a new one.
      unless wi
        wi = WeatherInfo.new({
          location_name: weather_details[:location_name],
          temperature: weather_details[:temperature],
          temperature_unit: weather_details[:temperature_unit],
          long_description: weather_details[:long_description],
          short_description: weather_details[:short_description],
          last_updated_at: Time.zone.now
        })
      end

      # Add the given location to the tags for the weather record.
      wi.location_list.add(location)
      wi.save

      wi
    end

  end
end
