class CreateMemeSearches < ActiveRecord::Migration
  def change
    create_table :meme_searches do |t|
      t.string :search_term, null: false
      t.integer :searches_count, default: 0, null: false
      t.timestamps
    end
  end
end
