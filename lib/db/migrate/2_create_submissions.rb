class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer  :user_id,        null: false

      t.string   :state
      t.string   :language
      t.string   :slug
      t.string   :code
      t.datetime :at
      t.datetime :approved_at
      t.datetime :done_at
      t.boolean  :is_liked
      t.boolean  :wants_opinions, null: false
      t.integer  :nit_count,      null: false
      t.integer  :version
      t.string   :stash_name

      t.string :viewers
      t.string :liked_by
      t.string :muted_by
    end
  end
end

