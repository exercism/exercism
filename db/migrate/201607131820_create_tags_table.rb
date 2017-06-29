class CreateTagsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :tags, [:name], unique: true
  end
end
