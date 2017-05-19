class WarnAboutCollapsedMigrations < ActiveRecord::Migration[4.2]
  def change
    puts "Please delete and recreate your development and test databases"
  end
end
