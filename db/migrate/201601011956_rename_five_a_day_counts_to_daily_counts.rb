class RenameFiveADayCountsToDailyCounts < ActiveRecord::Migration[4.2]
  def up
    rename_table :five_a_day_counts, :daily_counts
  end

  def down
    rename_table :daily_counts, :five_a_day_counts
  end
end
