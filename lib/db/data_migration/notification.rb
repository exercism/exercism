class Notification
  include Mongoid::Document
  field :re, as: :regarding, type: String
  field :r, as: :read, type: Boolean, default: false
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :count, type: Integer, default: 0
  field :n, as: :note, type: String # only for custom notifications
  belongs_to :user, index: true
  belongs_to :submission

  def pg_attributes
    {
      regarding: regarding,
      read: read,
      created_at: at,
      count: count,
      note: note,
      mongoid_id: id.to_s,
      mongoid_user_id: user_id.to_s,
      mongoid_submission_id: submission_id.to_s # might be nil
    }
  end
end

class PGNotification < ActiveRecord::Base
  table_name :notifications
end

