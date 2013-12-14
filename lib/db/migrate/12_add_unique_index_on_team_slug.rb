class AddUniqueIndexOnTeamSlug < ActiveRecord::Migration
  def change
    add_index :teams, :slug, unique: true
  end
end