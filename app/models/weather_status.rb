class WeatherStatus < ActiveRecord::Base
  # Tag locations since many search terms may refer to a single location.
  # Eg - The "90001" and "Los Angeles" location tags would
  #      both refer to the city of Los Angeles.
  acts_as_taggable_on :location

  scope :updated_after, ->(time) { where("last_updated_at > ?", time) }
end
