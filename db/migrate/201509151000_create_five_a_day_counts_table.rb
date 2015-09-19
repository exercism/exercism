class CreateFiveADayCountsTable < ActiveRecord::Migration
  def change
  	create_table :five_a_day_counts do |t|
      t.integer :user_id, null: false
      t.integer :total, null: false

      t.timestamps null: false
    end

    add_index :five_a_day_counts, [:user_id, :total], unique: true
  end
end
