class Comment
  include Mongoid::Document
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :comment, type: String
  field :hc, as: :html_comment, type: String
  belongs_to :user
  belongs_to :submission

  def pg_attributes
    {
      created_at: at,
      body: comment,
      html_body: html_comment,
      mongoid_id: id.to_s,
      mongoid_user_id: user_id.to_s,
      mongoid_submission_id: submission_id.to_s
    }
  end
end

class PGComment < ActiveRecord::Base
  self.table_name = :comments
end

