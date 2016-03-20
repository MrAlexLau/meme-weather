require 'rails_helper'

describe ImageService do
  let(:search_term) { 'dog sunny meme' }
  subject { ImageService }

  describe "#search" do
    it "returns a link" do
      VCR.use_cassette("image_search", record: :none) do
        expect(subject.search(search_term)).to start_with("http")
      end
    end
  end
end
