require 'rails_helper'

describe ImageService do
  let(:search_term) { 'dog sunny meme' }
  subject { ImageService }

  describe "#search" do
    it "returns a list of image links" do
      VCR.use_cassette("image_search", record: :none) do
        results = subject.search(search_term)
        results.each do |link|
          expect(link).to start_with("http")
        end
      end
    end
  end
end
