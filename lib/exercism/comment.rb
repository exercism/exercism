class Comment
  include Mongoid::Document
  include InputSanitation

  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :comment, type: String

  belongs_to :user
  belongs_to :nit
  belongs_to :submission

  def nitpicker
    user
  end

  def sanitized_update(comment)
    self.comment = sanitize(comment)
    save
  end
end
