class InitialSchema < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.text     :body
      t.text     :html_body

      t.timestamps               null: false
    end

    create_table :notifications do |t|
      t.integer  :user_id,       null: false
      t.integer  :item_id
      t.string   :item_type

      t.string   :regarding
      t.boolean  :read
      t.integer  :count,         null: false, default: 0

      t.timestamps               null: false
    end

    create_table :submissions do |t|
      t.integer  :user_id,        null: false
      t.string   :key

      t.string   :state
      t.string   :language
      t.string   :slug
      t.text     :code
      t.datetime :done_at
      t.boolean  :is_liked
      t.integer  :nit_count,      null: false
      t.integer  :version
      t.integer  :user_exercise_id
      t.string   :filename

      t.timestamps                null: false
    end
    add_index :submissions, :key
    add_index :submissions, :user_exercise_id

    create_table :users do |t|
      t.string   :username
      t.string   :email
      t.string   :avatar_url
      t.integer  :github_id
      t.string   :key

      t.text :mastery

      t.timestamps null: false
    end
    add_index :users, :username

    create_table :teams do |t|
      t.integer :creator_id, null: false
      t.string  :slug,       null: false
      t.string  :name

      t.timestamps           null: false
    end

    add_index :teams, :slug, unique: true

    create_table :team_memberships do |t|
      t.integer :team_id, null: false
      t.integer :user_id, null: false
      t.boolean :confirmed

      t.timestamps null: false
    end

    create_table :submission_viewers do |t|
      t.integer :submission_id, null: false
      t.integer :viewer_id, null: false

      t.timestamps null: false
    end

    add_index :submission_viewers, [:submission_id, :viewer_id], unique: true, name: 'by_submission'

    create_table :muted_submissions do |t|
      t.integer :submission_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    create_table :likes do |t|
      t.integer :submission_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    create_table :log_entries do |t|
      t.integer  :user_id
      t.text     :body
      t.timestamps null: false
    end

    create_table :user_exercises do |t|
      t.integer   :user_id,       null: false
      t.string    :language
      t.string    :slug
      t.integer   :iteration_count
      t.string    :state
      t.timestamp :completed_at
      t.string    :key

      t.timestamps                null: false
    end

    add_index :user_exercises, :user_id
    add_index :user_exercises, [:language, :slug, :state]
    add_index :user_exercises, [:user_id, :language, :slug], unique: true
    add_index :user_exercises, :key, unique: true

    create_table :alerts do |t|
      t.integer   :user_id,       null: false
      t.text      :text
      t.string    :url
      t.string    :link_text
      t.boolean   :read
      t.timestamps                null: false
    end

    add_index :alerts, :user_id
  end
end
