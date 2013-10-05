class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :creator_id, null: false
      t.string  :slug,       null: false

      t.timestamps

      t.string :mongoid_id
      t.string :mongoid_creator_id
    end
    add_index :teams, :mongoid_id, unique: true
    add_index :teams, :mongoid_creator_id
  end
end
