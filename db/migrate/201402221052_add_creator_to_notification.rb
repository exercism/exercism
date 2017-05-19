class AddCreatorToNotification < ActiveRecord::Migration[4.2]
  def change
    add_reference :notifications, :creator
  end
end
