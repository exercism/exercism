class DailyCount < ActiveRecord::Base
  belongs_to :user

  def self.today
    find_by_day(Date.today)
  end
end
