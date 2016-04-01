require 'rails_helper'

describe WeatherQuery do
  subject { WeatherQuery }

  describe "#find_or_create_by_location" do
    context "when a record exists tagged with the given search term" do
      let(:search_term) { '90210' }

      context "and the record was updated within the last hour" do
        let!(:existing_status) {
          ws = create(:weather_status)
          ws.location_list.add(search_term)
          ws.save
          ws
        }

        it "returns the existing weather information" do
          expect(subject.find_or_create_by_location(search_term)).to eq(existing_status)
        end
      end

      context "but the record was created over an hour ago" do
        let!(:existing_status) {
          ws = create(:weather_status)
          ws.location_list.add(search_term)
          ws.last_updated_at = (Time.zone.now - 2.hours)
          ws.save
          ws
        }

        it "creates a new record" do
          count_before = WeatherStatus.count

          VCR.use_cassette("current_weather", record: :none) do
            subject.find_or_create_by_location(search_term)
          end

          expect(WeatherStatus.count).to eq(count_before + 1)
        end

        it "tags the new record with the search term" do
          VCR.use_cassette("current_weather", record: :none) do
            expect(subject.find_or_create_by_location(search_term).location_list).to include(search_term)
          end
        end
      end
    end

    context "when no record exists tagged with the given search term" do
      let(:search_term) { 'New York' }

      it "creates a new record" do
        count_before = WeatherStatus.count

        VCR.use_cassette("current_weather", record: :none) do
          subject.find_or_create_by_location(search_term)
        end

        expect(WeatherStatus.count).to eq(count_before + 1)
      end

      it "tags the new record with the search term" do
        VCR.use_cassette("current_weather", record: :none) do
          expect(subject.find_or_create_by_location(search_term).location_list).to include(search_term)
        end
      end
    end
  end
end
