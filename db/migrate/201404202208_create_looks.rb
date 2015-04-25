class CreateLooks < ActiveRecord::Migration
  def change
    create_table :looks do |t|
      t.integer  :user_id,       null: false
      t.integer  :exercise_id,   null: false

      t.timestamps               null: false
    end
  end
end
