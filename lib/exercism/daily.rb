class Daily < ActiveRecord::Base
  belongs_to :user
  LIMIT = 5
end
