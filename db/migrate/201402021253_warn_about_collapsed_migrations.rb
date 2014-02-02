class WarnAboutCollapsedMigrations < ActiveRecord::Migration
  def change
    puts "Please delete and recreate your development and test databases"
  end
end
