class Nitstats
  def initialize(user)
    @user = user
  end

  def data
    {
      labels: labels,
      given: given,
      received: received,
      steps: steps,
      step: step
    }
  end

  private

  def labels
    (from..to).map { |d| d.strftime "%d/%m" }
  end

  def given
    sql = "select date(c.created_at) as date, count(1) as count
           from comments c, submissions s
           where c.user_id = #{user.id}
           and c.submission_id = s.id
           and s.user_id != #{user.id}
           group by date(c.created_at) order by date(c.created_at)"
    extract_stat ActiveRecord::Base.connection.execute(sql)
  end

  def received
    sql = "select date(c.created_at) as date, count(1) as count
           from comments c, submissions s
           where c.user_id != #{user.id}
           and c.submission_id = s.id
           and s.user_id = #{user.id}
           group by date(c.created_at) order by date(c.created_at)"
    extract_stat ActiveRecord::Base.connection.execute(sql)
  end

  def from
    29.days.ago.to_date
  end

  def to
    Date.today
  end

  def max
    [received.max, given.max].max
  end

  def steps
    max / step
  end

  def step
    [max / 15, 1].max
  end

  attr_reader :user

  def extract_stat(results)
    results = results.reduce({}) { |acc, r| acc.merge(r["date"] => r["count"]) }
    (from..to).map { |d| results[d.to_s].to_i }
  end

end
