class ChangeDefaultValueToUserSource < ActiveRecord::Migration
  def change
    change_column_default :users, :source_type, "GITHUB"
  end
end
