class MemeQuery
  class << self
    MIN_RANKING = 0

    def find_or_create_by_tags(tags)
      memes = filtered_memes(tags)

      # If no images are found, fetch some.
      unless memes.any?
        fetch_memes!(tags)
        memes = filtered_memes(tags)
      end

      memes.sample
    end

    private

    def filtered_memes(tags)
      # Example of some tags: ["cat", "rainy", "meme"]
      MemeImage.tagged_with(tags).where("rating >= ?", MIN_RANKING)
    end

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
