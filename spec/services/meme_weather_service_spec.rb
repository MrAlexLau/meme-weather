require 'rails_helper'

# TODO: fully test this class
describe MemeWeatherService do
  let(:location) { 'Austin' }
  subject { MemeWeatherService.new(location) }

  describe "#fetch_details" do
    it "returns weather information" do
      expect(subject.fetch_details.keys).to include(:location_name)
    end

    it "returns a meme image link" do
      expect(subject.fetch_details.keys).to include(:meme_image_link)
    end
  end
end
