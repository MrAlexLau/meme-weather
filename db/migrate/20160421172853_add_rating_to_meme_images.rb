class AddRatingToMemeImages < ActiveRecord::Migration
  def change
    add_column :meme_images, :rating, :integer, null: false, default: 0
  end
end
