class DeleteWantsOpinionsFromSubmission < ActiveRecord::Migration
  def change
    remove_column :submissions, :wants_opinions
  end
end
