class CreateDeletedIterations < ActiveRecord::Migration
  def change
    create_table :deleted_iterations do |t|
      t.integer  :user_id,          null: false
      t.integer  :submission_id,    null: false
      t.timestamps                  null: false
    end
    add_index :deleted_iterations, :submission_id
    add_index :deleted_iterations, :user_id
    add_index :deleted_iterations, [:user_id, :submission_id], unique: true, name: "index_conversation_subscriptions_on_user_submission"
  end
end
