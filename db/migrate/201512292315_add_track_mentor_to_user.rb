class AddTrackMentorToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :track_mentor, :text
  end
end
