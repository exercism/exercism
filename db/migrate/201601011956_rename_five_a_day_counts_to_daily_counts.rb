class RenameFiveADayCountsToDailyCounts < ActiveRecord::Migration
  def up
    rename_table :five_a_day_counts, :daily_counts
  end

  def down
    rename_table :daily_counts, :five_a_day_counts
  end
end
