class Submission
  include Mongoid::Document
  field :state, type: String, default: 'pending'
  field :l, as: :language, type: String
  field :s, as: :slug, type: String
  field :c, as: :code, type: String
  field :at, type: Time, default: ->{ Time.now.utc }
  field :d_at, as: :done_at, type: Time
  field :lk, as: :is_liked, type: Boolean, default: false
  field :op, as: :wants_opinions, type: Boolean, default: false
  field :nc, as: :nit_count, type: Integer, default: 0 # nits by others
  field :v, as: :version, type: Integer, default: 0
  field :st_n, as: :stash_name, type: String
  field :lk_by, as: :liked_by, type: Array, default: []
  field :mt_by, as: :muted_by, type: Array, default: []
  field :vs, as: :viewers, type: Array, default: []
  belongs_to :user

  def pg_attributes
    {
      state: state,
      language: language,
      slug: slug,
      code: code,
      created_at: at,
      done_at: done_at,
      is_liked: is_liked,
      wants_opinions: wants_opinions,
      nit_count: nit_count,
      version: version,
      stash_name: stash_name,
      mongoid_id: id.to_s,
      mongoid_user_id: user_id.to_s,
      liked_by: liked_by,
      viewers: viewers
    }
    # muted_by - I think it should be a relation. We want to filter on it.
    # We'll need a :mutes or :muted_submissions table or something?
  end
end

class PGSubmission < ActiveRecord::Base
  self.table_name = :submissions
  serialize :liked_by, Array
  serialize :viewers, Array
end

