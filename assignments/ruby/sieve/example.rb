class Sieve

  attr_reader :range
  def initialize(limit)
    @range = (2..limit)
  end

  def primes
    @primes ||= calculate
  end

  private
  def calculate
    numbers = range.to_a
    primes = []
    begin
      target = numbers.shift
      primes << target
      numbers.reject! {|i| i % target == 0 }
    end until numbers.empty?
    primes
  end

end

