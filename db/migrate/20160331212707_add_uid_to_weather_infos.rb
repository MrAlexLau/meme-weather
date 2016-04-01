class AddUidToWeatherInfos < ActiveRecord::Migration
  def change
    add_column :weather_infos, :location_uid, :string, null: false
  end
end
