require 'uri'

class ImageService
  class << self

    # Returns a list of image urls based on the given search term.
    def search(term)
      escaped_term = URI.escape(term)
      api_key = Rails.application.secrets.google_cse_api_key
      google_cx = Rails.application.secrets.google_cse_cx
      url = "https://www.googleapis.com/customsearch/v1?searchType=image&q=#{escaped_term}&cx=#{google_cx}&key=#{api_key}"

      parse_response(HTTParty.get(url))
    end

    private

    def parse_response(response)
      response = response.deep_symbolize_keys
      response[:items].map {|item| item[:link] }
    end
  end
end
