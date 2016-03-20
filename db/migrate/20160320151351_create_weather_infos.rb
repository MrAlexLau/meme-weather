class CreateWeatherInfos < ActiveRecord::Migration
  def self.up
    create_table :weather_infos  do |t|
      t.string :location_name, :null => false
      t.float :temperature, :null => false
      t.string :temperature_unit, :null => false
      t.string :long_description, :null => false
      t.string :short_description, :null => false
      t.datetime :last_updated_at
    end
  end

  def self.down
    drop_table :weather_infos
  end
end
