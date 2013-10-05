class MigrationPeriods
  include Enumerable

  def each
    all.each { |period| yield(period) }
  end

  def all
    @all ||= generate_periods
  end

  private

  def launched_on
    @launched_on ||= Date.new(2013, 6, 13)
  end

  def migrate_to
    @migrate_to ||= Date.today + 1
  end

  def generate_periods
    periods = []
    date = launched_on
    while date <= migrate_to
      timeframe = Timeframe.new(date)
      periods << timeframe
      date = timeframe.end_date
    end
    periods
  end
end

