# One week, midnight to midnight
class Timeframe
  attr_reader :start_date
  def initialize(start_date)
    @start_date = start_date
  end

  def end_date
    @end_date ||= start_date + 7
  end

  def mongoid_criteria(field)
    {
      :"#{field}".gte => start_date.to_time,
      :"#{field}".lte => end_date.to_time
    }
  end

  def pg_criteria
    "created_at BETWEEN '#{format(start_date)}' AND '#{format(end_date)}'"
  end

  def to_s
    "#<Timeframe: #{start_date} to #{end_date}>"
  end

  private

  def format(date)
    date.strftime('%Y-%m-%d')
  end
end

