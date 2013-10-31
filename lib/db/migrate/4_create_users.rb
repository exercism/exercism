class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username
      t.string   :email
      t.string   :avatar_url
      t.integer  :github_id
      t.string   :key

      t.text :mastery
      t.text :current
      t.text :completed

      t.timestamps

      t.string :mongoid_id
    end
    add_index :users, :mongoid_id, unique: true
  end
end

