# This will guess the User class
FactoryGirl.define do
  factory :weather_status do
    location_uid "lat:123::lon:456"
    location_name "Austin"
    temperature 54.32
    temperature_unit "F"
    long_description "light rain"
    short_description "Rain"
    last_updated_at Time.zone.now
  end

  factory :meme_image do
    image_url 'http://example.com/image.png'
  end
end
