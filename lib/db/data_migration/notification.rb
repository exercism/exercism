class Notification
  include Mongoid::Document
  field :re, as: :regarding, type: String
  field :r, as: :read, type: Boolean, default: false
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :count, type: Integer, default: 0
  field :n, as: :note, type: String # only for custom notifications
  belongs_to :user, index: true
  belongs_to :submission

  def self.unmigrated_in(timeframe)
    where(timeframe.mongoid_criteria(:at)).not_in(id: PGNotification.migrated_ids(timeframe))
  end

  def pg_user
    @pg_user ||= PGUser.find_by_mongoid_id(user_id.to_s)
  end

  def pg_submission
    @pg_submission ||= PGSubmission.find_by_mongoid_id(submission_id.to_s)
  end

  def pg_submission_id
    pg_submission.id if submission_id
  end

  def mongoid_submission_id
    submission_id.to_s if submission_id
  end

  def pg_attributes
    {
      regarding: regarding,
      read: read,
      created_at: at,
      count: count,
      note: note,
      user_id: pg_user.id,
      submission_id: pg_submission_id, # might be nil
      mongoid_id: id.to_s,
      mongoid_user_id: user_id.to_s,
      mongoid_submission_id: mongoid_submission_id # might be nil
    }
  end
end

class PGNotification < ActiveRecord::Base
  self.table_name = :notifications

  def self.migrated_ids(timeframe)
    where(timeframe.pg_criteria).pluck(:mongoid_id)
  end
end

