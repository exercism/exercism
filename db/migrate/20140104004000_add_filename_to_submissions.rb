class AddFilenameToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :filename, :string
  end
end