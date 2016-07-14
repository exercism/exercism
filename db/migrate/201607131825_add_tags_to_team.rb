class AddTagsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :tags, :integer, array: true, default: []
    add_index  :teams, [:tags], using: :gin
  end
end
