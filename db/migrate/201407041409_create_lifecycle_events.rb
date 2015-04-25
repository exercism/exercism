class CreateLifecycleEvents < ActiveRecord::Migration
  def change
    create_table :lifecycle_events do |t|
      t.integer   :user_id
      t.string    :key
      t.timestamp :happened_at
      t.timestamps               null: false
    end
  end
end
