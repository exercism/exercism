class Notification
  include Mongoid::Document
  belongs_to :user
end

