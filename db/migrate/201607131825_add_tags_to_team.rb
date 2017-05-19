class AddTagsToTeam < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :tags, :integer, array: true, default: []
    add_index  :teams, [:tags], using: :gin
  end
end
