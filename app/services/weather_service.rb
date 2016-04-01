require 'open_weather'

class WeatherService

  class << self
    def current_weather(location)
      options = {
        units: "imperial",
        APPID: Rails.application.secrets.open_weather_app_id
      }

      response = OpenWeather::Current.city("#{location},us", options)

      {
        temperature_unit: 'F', # Since imperial was used
      }.merge(parse_response(response))
    end

    private

    def parse_response(response)
      response = response.deep_symbolize_keys

      {
        location_uid: parse_uid(response),
        location_name: response[:name],
        temperature: response[:main][:temp],
        long_description: response[:weather].first[:description],
        short_description: response[:weather].first[:main]
      }
    end

    def parse_uid(response)
      # Create a string that uniquely identifies a location.
      # Eg - to differentiate between Austin, TX and Austin, AR.
      "lat:#{response[:coord][:lon]}::lon:#{response[:coord][:lat]}"
    end
  end
end
