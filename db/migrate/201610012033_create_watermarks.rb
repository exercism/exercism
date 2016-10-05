class CreateWatermarks < ActiveRecord::Migration
  def change
    create_table :watermarks do |t|
      t.integer   :user_id, null: false
      t.string    :track_id, null: false
      t.string    :slug, null: false
      t.timestamp :at, null: false
    end
    add_index :watermarks, [:user_id, :track_id, :slug], unique: true, name: "index_watermarks_on_user_track_slug"
    add_index :watermarks, :user_id
  end
end
