class Say

  attr_reader :value
  def initialize(value)
    @value = value
  end

  def chunks
    guard_range

    res = []
    value.to_s.rjust(12, '0').chars.each_slice(3) do |slice|
      res << slice.join('').to_i
    end
    res
  end

  private

  def guard_range
    unless in_range?
      message = 'Number must be between 0 and 999,999,999,999 inclusive.'
      raise ArgumentError.new(message)
    end
  end

  def in_range?
    value >= 0 && value < 10**12
  end
end

