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

  def self.unmigrated_in(timeframe)
    where(timeframe.mongoid_criteria(:at)).not_in(id: PGSubmission.migrated_ids(timeframe))
  end

  def pg_user
    @pg_user ||= PGUser.find_by_mongoid_id(user_id.to_s)
  end

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
      user_id: pg_user.id,
      mongoid_id: id.to_s,
      mongoid_user_id: user_id.to_s,
    }
  end
end

class PGSubmission < ActiveRecord::Base
  self.table_name = :submissions

  def self.migrated_ids(timeframe)
    where(timeframe.pg_criteria).pluck(:mongoid_id)
  end
end

class SubmissionViewer < ActiveRecord::Base
end

class MutedSubmission < ActiveRecord::Base
end
