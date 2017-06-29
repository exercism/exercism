class RmDeprecatedSolutionFieldsFromSubmission < ActiveRecord::Migration[4.2]
  def up
    remove_column :submissions, :code
    remove_column :submissions, :filename
  end

  def down
    add_column :submissions, :code, :text
    add_column :submissions, :filename, :string
  end
end
