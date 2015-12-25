class DropTableLooks < ActiveRecord::Migration
  def up
    drop_table :looks
  end

  def down
    create_table :looks do |t|
      t.integer  :user_id,       null: false
      t.integer  :exercise_id,   null: false

      t.timestamps               null: false
    end
  end
end
