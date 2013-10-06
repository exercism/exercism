class Comment
  include Mongoid::Document
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :comment, type: String
  field :hc, as: :html_comment, type: String
  belongs_to :user
  belongs_to :submission

  def self.unmigrated_in(timeframe)
    where(timeframe.mongoid_criteria(:at)).not_in(id: PGComment.migrated_ids(timeframe))
  end

  def pg_user
    @pg_user ||= PGUser.find_by_mongoid_id(user_id.to_s)
  end

  def pg_submission
    @pg_submission ||= PGSubmission.find_by_mongoid_id(submission_id.to_s)
  end

  def pg_attributes
    {
      created_at: at,
      body: comment,
      html_body: html_comment,
      user_id: pg_user.id,
      submission_id: pg_submission.id,
      mongoid_id: id.to_s,
      mongoid_user_id: user_id.to_s,
      mongoid_submission_id: submission_id.to_s
    }
  end
end

class PGComment < ActiveRecord::Base
  self.table_name = :comments

  def self.migrated_ids(timeframe)
    where(timeframe.pg_criteria).pluck(:mongoid_id)
  end
end

