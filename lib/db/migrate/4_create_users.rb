class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username
      t.string   :email
      t.string   :avatar_url
      t.integer  :github_id
      t.string   :key
      t.datetime :j_at

      t.datetime :at
      t.text     :comment
      t.text     :html_comment

      t.string :mastery
      t.string :current
      t.string :completed
    end
  end
end

