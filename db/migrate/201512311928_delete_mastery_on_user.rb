class DeleteMasteryOnUser < ActiveRecord::Migration
  def up
    remove_column :users, :mastery
  end

  def down
    add_column :users, :mastery, :text
  end
end
