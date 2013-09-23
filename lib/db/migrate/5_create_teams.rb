class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :creator_id, null: false
      t.string  :slug,       null: false
    end
  end
end
