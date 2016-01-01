class AddTrackMentorToUser < ActiveRecord::Migration
  def change
    add_column :users, :track_mentor, :text
  end
end
