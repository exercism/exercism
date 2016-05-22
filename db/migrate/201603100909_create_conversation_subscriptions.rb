class CreateConversationSubscriptions < ActiveRecord::Migration
  def change
    create_table :conversation_subscriptions do |t|
      t.integer  :user_id,          null: false
      t.integer  :solution_id,      null: false
      t.boolean  :subscribed,       default: true
      t.timestamps                  null: false
    end
    add_index :conversation_subscriptions, :solution_id
    add_index :conversation_subscriptions, :user_id
    add_index :conversation_subscriptions, [:user_id, :solution_id], unique: true, name: "index_conversation_subscriptions_on_user_solution"
  end
end
