class RenameWeatherInfosToWeatherStatuses < ActiveRecord::Migration
   def change
     rename_table :weather_infos, :weather_statuses
   end
 end
