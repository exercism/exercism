class Meetup

  def self.prefixes_of_the_week
    [:sun, :mon, :tues, :wednes, :thurs, :fri, :satur]
  end

  def self.weekday_number(prefix)
    prefixes_of_the_week.index(prefix)
  end

  attr_reader :year, :number
  def initialize(number, year)
    @year = year
    @number = number
  end

  prefixes_of_the_week.each do |prefix|
    define_method "#{prefix}teenth".to_sym do
      message = "days_til_#{prefix}day".to_sym
      thirteenth + send(message, thirteenth)
    end

    define_method "first_#{prefix}day".to_sym do
      message = "days_til_#{prefix}day".to_sym
      first + send(message, first)
    end

    define_method "second_#{prefix}day".to_sym do
      message = "days_til_#{prefix}day".to_sym
      eighth + send(message, eighth)
    end

    define_method "third_#{prefix}day".to_sym do
      message = "days_til_#{prefix}day".to_sym
      fifteenth + send(message, fifteenth)
    end

    define_method "fourth_#{prefix}day".to_sym do
      message = "days_til_#{prefix}day".to_sym
      twenty_second + send(message, twenty_second)
    end

    define_method "last_#{prefix}day".to_sym do
      message = "days_since_#{prefix}day".to_sym
      last - send(message, last)
    end

    define_method "days_til_#{prefix}day".to_sym do |day|
      (self.class.weekday_number(prefix) - day.wday) % 7
    end

    define_method "days_since_#{prefix}day".to_sym do |day|
      (7 - (self.class.weekday_number(prefix) - day.wday)) % 7
    end
  end

  private

  def first
    @first ||= Date.new(year, number, 1)
  end

  def eighth
    @eighth ||= Date.new(year, number, 8)
  end

  def thirteenth
    @thirteenth ||= Date.new(year, number, 13)
  end

  def fifteenth
    @fifteenth ||= Date.new(year, number, 15)
  end

  def twenty_second
    @twenty_second ||= Date.new(year, number, 22)
  end

  def last
    @last ||= Date.new(year, number, -1)
  end

end

