class Api::WeatherMemesController < ApplicationController
  def search
    save_settings!
    theme = parse_theme(params[:theme])
    weather_status = WeatherQuery.find_or_create_by_location(params[:location])
    themed_search_terms = [theme, weather_status.short_description, "meme"]
    meme = MemeQuery.find_or_create_by_tags(themed_search_terms)
    save_search!(themed_search_terms)

    render json: {
      location_name: weather_status.location_name,
      temperature: weather_status.temperature,
      temperature_unit: weather_status.temperature_unit,
      weather_conditions: weather_status.long_description,
      meme_image_link: meme.image_url,
    }
  end

  private

  # Convert the 'none' theme to a blank string
  # when searching for a meme.
  def parse_theme(theme)
    theme == 'none' ? '' : theme
  end

  def save_settings!
    new_settings = {
      theme: params[:theme],
      search_term: params[:location]
    }

    session[:settings] = new_settings
  end

  def save_search!(search_terms)
    search_term = search_terms.sort.join(" ")
    ms = MemeSearch.find_or_initialize_by({ search_term:  search_term })
    ms.searches_count += 1
    ms.save
  end
end
