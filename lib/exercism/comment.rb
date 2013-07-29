class Comment
  include Mongoid::Document

  field :at, type: Time, default: ->{ Time.now.utc }
  field :body, type: String

  belongs_to :user
  embedded_in :nit

  def commenter
    user
  end
end
