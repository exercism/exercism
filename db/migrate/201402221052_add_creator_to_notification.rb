class AddCreatorToNotification < ActiveRecord::Migration
  def change
    add_reference :notifications, :creator
  end
end
