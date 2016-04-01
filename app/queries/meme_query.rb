class MemeQuery
  class << self
    def find_or_create_by_tags(tags)
      # Example of some tags: ["cat", "rainy", "meme"]
      memes = MemeImage.tagged_with(tags)

      # TODO: ranking and filtering could go here

      # If no images are found, fetch some.
      fetch_memes!(tags) unless memes.any?

      MemeImage.tagged_with(tags).sample
    end

    private

    def fetch_memes!(tags)
      links = ImageService.search(tags.join(" "))

      links.each do |link|
        meme = MemeImage.find_or_create_by(image_url: link)

        tags.each do |tag|
          meme.tag_list.add(tag)
        end

        meme.save
      end
    end
  end

end
