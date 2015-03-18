class AddTestOutputToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :test_output, :text
  end
end
