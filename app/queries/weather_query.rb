class WeatherQuery
  class << self
    # Query weather data. Whether that means looking it up
    # in a db table or fetching the data from a service.
    def find_by_location(location, opts={})
      options = default_options(opts)

      time_threshold = Time.zone.now - options[:timeframe]

      current_weather = WeatherInfo.updated_after(time_threshold).tagged_with(location).first

      # Only call weather_from_service if no existing record is found.
      current_weather ||= weather_from_service(location, time_threshold)
    end

    private

    def default_options(options)
      {
        timeframe: 1.hour
      }.merge(options)
    end

    def weather_from_service(location, time_threshold)
      current_weather = WeatherService.current_weather(location)

      # After the service normalizes the location unique identifier,
      # check to see if any other records already match this location.
      weather_info = WeatherInfo.updated_after(time_threshold).where(location_uid: current_weather[:location_uid]).first

      # If no record is found, create a new one.
      unless weather_info
        weather_info = weather_info_from_response(current_weather)
      end

      # Add the given location to the tags for the weather record.
      weather_info.location_list.add(location)
      weather_info.save

      weather_info
    end

    def weather_info_from_response(weather_response)
      WeatherInfo.new({
        location_uid: weather_response[:location_uid],
        location_name: weather_response[:location_name],
        temperature: weather_response[:temperature],
        temperature_unit: weather_response[:temperature_unit],
        long_description: weather_response[:long_description],
        short_description: weather_response[:short_description],
        last_updated_at: Time.zone.now
      })
    end
  end
end
