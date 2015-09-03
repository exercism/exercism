class CreateAclsTable < ActiveRecord::Migration
  def change
    create_table :acls do |t|
      t.integer :user_id, null: false
      t.string :language, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :acls, [:user_id, :language, :slug], unique: true
  end
end
