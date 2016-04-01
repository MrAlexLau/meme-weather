class CreateMemeImages < ActiveRecord::Migration
  def change
    create_table :meme_images do |t|
      t.string :image_url, :null => false
      t.timestamps
    end
  end
end
