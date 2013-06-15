class Say

  attr_reader :value
  def initialize(value)
    @value = value
  end

  def in_english
    guard_range
    if value < 20
      say_small_number
    else
      say_big_number
    end
  end

  private

  def say_small_number
    small_numbers[value]
  end

  def say_big_number
    s = decades[tens]
    unless ones.zero?
      s << "-#{small_numbers[ones]}"
    end
    s
  end

  def guard_range
    unless in_range?
      message = 'Number must be between 0 and 99, inclusive.'
      raise ArgumentError.new(message)
    end
  end

  def in_range?
    value >= 0 && value < 100
  end

  def tens
    @tens ||= value / 10
  end

  def ones
    @ones ||= value % 10
  end

  def small_numbers
    %w(zero one two three four five
       six seven eight nine ten
       eleven twelve thirteen fourteen fifteen
       sixteen seventeen eighteen nineteen)
  end

  def decades
    [nil, nil] +
    %w(twenty thirty forty fifty
       sixty seventy eighty ninety)
  end

end

