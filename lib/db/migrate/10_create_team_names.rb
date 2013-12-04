class CreateTeamNames < ActiveRecord::Migration
  class Team < ActiveRecord::Base
    # Just for the purpose of the migration
  end

  def up
    add_column :teams, :name, :string
    Team.update_all 'name=slug'
  end

  def down
    remove_column :teams, :name
  end
end
