class Meetup

  def self.days_of_week
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  end

  def self.weekday_number(weekday)
    days_of_week.index(weekday)
  end

  attr_reader :year, :number
  def initialize(number, year)
    @year = year
    @number = number
    @first = Date.new(year, number, 1)
    @eighth = Date.new(year, number, 8)
    @thirteenth = Date.new(year, number, 13)
    @fifteenth = Date.new(year, number, 15)
    @twenty_second = Date.new(year, number, 22)
    @last = Date.new(year, number, -1)
  end

  def day(weekday, schedule)
    case schedule
    when :teenth then
      @thirteenth + days_til(weekday, @thirteenth)
    when :first then 
      @first + days_til(weekday, @first)
    when :second then 
      @eighth + days_til(weekday, @eighth)
    when :third then 
      @fifteenth + days_til(weekday, @fifteenth)
    when :fourth then 
      @twenty_second + days_til(weekday, @twenty_second)
    when :last then
      @last - (7 - (self.class.weekday_number(weekday) - @last.wday)) % 7
    end
  end

  private
    
  def days_til(weekday, day)
    (self.class.weekday_number(weekday) - day.wday) % 7
  end
end

