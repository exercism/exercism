class InitialSchema < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.text     :body
      t.text     :html_body

      t.timestamps
    end

    create_table :notifications do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id  # might be null

      t.string   :regarding
      t.boolean  :read
      t.integer  :count,         null: false, default: 0
      t.string   :note

      t.timestamps
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
      t.boolean  :wants_opinions, null: false
      t.integer  :nit_count,      null: false
      t.integer  :version
      t.string   :stash_name

      t.timestamps
    end
    add_index :submissions, :key

    create_table :users do |t|
      t.string   :username
      t.string   :email
      t.string   :avatar_url
      t.integer  :github_id
      t.string   :key

      t.text :mastery

      t.timestamps
    end
    add_index :users, :username

    create_table :teams do |t|
      t.integer :creator_id, null: false
      t.string  :slug,       null: false
      t.string  :name

      t.timestamps
    end

    add_index :teams, :slug, unique: true

    create_table :team_memberships do |t|
      t.integer :team_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    create_table :submission_viewers do |t|
      t.integer :submission_id, null: false
      t.integer :viewer_id, null: false

      t.timestamps
    end

    add_index :submission_viewers, [:submission_id, :viewer_id], unique: true, name: 'by_submission'

    create_table :muted_submissions do |t|
      t.integer :submission_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    create_table :likes do |t|
      t.integer :submission_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    create_table :log_entries do |t|
      t.integer  :user_id
      t.text     :body
      t.timestamps
    end
  end
end
