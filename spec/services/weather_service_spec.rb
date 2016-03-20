require 'rails_helper'

describe WeatherService do
  let(:location) { 'minneapolis' }
  subject { WeatherService }

  describe "#current_weather" do
    it "returns weather information for a given location" do
      expected_keys = [:location_name, :temperature, :temperature_unit, :long_description, :short_description]

      VCR.use_cassette("current_weather", record: :none) do
        expected_keys.each do |key|
          expect(subject.current_weather(location).keys).to include(key)
        end
      end
    end
  end
end
