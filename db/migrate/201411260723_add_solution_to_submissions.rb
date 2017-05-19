class AddSolutionToSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :submissions, :solution, :text
  end
end
