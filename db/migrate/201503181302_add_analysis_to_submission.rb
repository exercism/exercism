class AddAnalysisToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :analysis, :text
  end
end
