class User
  include Mongoid::Document

  field :u, as: :username, type: String
  field :email, type: String
  field :img, as: :avatar_url, type: String
  field :cur, as: :current, type: Hash, default: {}
  field :comp, as: :completed, type: Hash, default: {}
  field :g_id, as: :github_id, type: Integer
  field :key, type: String, default: ->{ create_key }
  field :j_at, type: Time, default: ->{ Time.now.utc }
  field :ms, as: :mastery, type: Array, default: []

  def pg_attributes
    {
      username: username,
      email: email,
      github_id: github_id,
      avatar_url: avatar_url,
      current: current,
      key: key,
      created_at: j_at,
      mastery: mastery,
      mongoid_id: id.to_s
    }
  end
end

class PGUser < ActiveRecord::Base
  table_name :users

  serialize :current, Hash
  serialize :completed, Hash
  serialize :mastery, Array
end

