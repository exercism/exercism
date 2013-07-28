class Notification
  include Mongoid::Document

  field :re, as: :regarding, type: String
  field :r, as: :read, type: Boolean, default: false
  field :l, as: :link, type: String
  field :f, as: :from, type: String
  field :at, type: Time, default: ->{ Time.now.utc }

  belongs_to :user

  def self.recent_for_user(user)
    where(user: user).limit(100).descending(:at)
  end
end

