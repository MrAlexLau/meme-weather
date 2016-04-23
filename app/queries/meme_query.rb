class MemeQuery
  class << self
    # Default min threshold for what rating a meme must have
    # to be visible to a user.
    MIN_RANKING = 0

    def find_or_create_by_tags(tags)
      memes = tagged_memes(tags)

      # If no images are found, fetch some.
      memes = create_by_tags(tags) unless memes.any?

      # Pick a random meme from the results.
      memes.sample
    end

    def create_by_tags(tags, options = {})
      fetch_memes!(tags, options)
      tagged_memes(tags)
    end

    def tagged_memes(tags)
      # Example of some tags: ["cat", "rainy", "meme"]
      MemeImage.tagged_with(tags).where("rating >= ?", MIN_RANKING)
    end

    private

    def fetch_memes!(tags, options = {})
      links = ImageService.search(tags.join(" "), options)

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
