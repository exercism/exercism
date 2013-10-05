class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer  :user_id,        null: false

      t.string   :state
      t.string   :language
      t.string   :slug
      t.string   :code
      t.datetime :done_at
      t.boolean  :is_liked
      t.boolean  :wants_opinions, null: false
      t.integer  :nit_count,      null: false
      t.integer  :version
      t.string   :stash_name

      t.timestamps

      t.string :mongoid_id
      t.string :mongoid_user_id
    end
    add_index :submissions, :mongoid_id, unique: true
    add_index :submissions, :mongoid_user_id
  end
end

