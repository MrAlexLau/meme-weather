require 'rails_helper'

describe MemeWeatherPresenter do
  let(:location) { 'Denver' }
  let(:theme) { 'dog' }
  subject { MemeWeatherPresenter }

  describe "#fetch_details" do
    it "returns weather information" do
      expected_keys = [:location_name, :temperature, :temperature_unit, :weather_conditions]

      VCR.use_cassette("meme_weather_service", record: :none) do
        expected_keys.each do |key|
          expect(subject.fetch_details(location, theme).keys).to include(key)
        end
      end
    end

    it "returns a meme image link" do
      VCR.use_cassette("meme_weather_service", record: :none) do
        expect(subject.fetch_details(location, theme).keys).to include(:meme_image_link)
      end
    end
  end
end
