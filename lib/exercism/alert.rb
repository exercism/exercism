class Alert < ActiveRecord::Base
  belongs_to :user

  def read!
    self.read = true
    save!
  end
end

