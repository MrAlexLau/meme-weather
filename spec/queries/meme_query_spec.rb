require 'rails_helper'

describe MemeQuery do
  subject { MemeQuery }

  describe "#find_or_create_by_tags" do
    context "when a record exists with the given tags" do
      let(:search_tags) { ["cat", "rainy", "meme"] }
      let!(:existing_meme) {
        image = create(:meme_image)
        image.tag_list.add(search_tags)
        image.save
        image
      }

      it "returns the existing image" do
        expect(subject.find_or_create_by_tags(search_tags)).to eq(existing_meme)
      end
    end

    context "when no record exists tagged with the given search term" do
      let(:search_tags) { ['dog', 'snowy', 'meme'] }

      it "creates a new record" do
        count_before = MemeImage.count

        VCR.use_cassette("image_search", record: :none) do
          subject.find_or_create_by_tags(search_tags)
        end

        expect(MemeImage.count).to be > count_before
      end

      it "tags the new record with the search term" do
        VCR.use_cassette("image_search", record: :none) do
          subject.find_or_create_by_tags(search_tags).tag_list.each do |tag|
            expect(search_tags).to include(tag)
          end
        end
      end
    end
  end
end
