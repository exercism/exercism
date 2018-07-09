class AddEtlIndices < ActiveRecord::Migration[5.1]
  def change
    add_index :submissions, [:language], name: "etl_submissions_1"
    add_index :submissions, [:language, :slug], name: "etl_submissions_2"
    add_index :submissions, [:language, :slug, :user_id], name: "etl_submissions_3"
    add_index :submissions, [:id, :language], name: "etl_submissions_4"
    add_index :comments, [:language], name: "etl_comments_1"
    add_index :comments, [:language, :submission_id], name: "etl_comments_2"
    add_index :likes, [:submission_id], name: "etl_likes_1"
  end
end
