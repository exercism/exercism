class DeleteMongoidMigrationFields < ActiveRecord::Migration
  def change
    remove_column :comments, :mongoid_id
    remove_column :comments, :mongoid_user_id
    remove_column :comments, :mongoid_submission_id
    remove_column :notifications, :mongoid_id
    remove_column :notifications, :mongoid_user_id
    remove_column :notifications, :mongoid_submission_id
    remove_column :submissions, :mongoid_id
    remove_column :submissions, :mongoid_user_id
    remove_column :users, :mongoid_id
    remove_column :teams, :mongoid_id
    remove_column :teams, :mongoid_creator_id
  end
end
