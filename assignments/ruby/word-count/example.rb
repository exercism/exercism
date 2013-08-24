class Phrase

  def initialize(source)
    @source = source
  end

  def word_count
    data = Hash.new(0)
    each_word do |word|
      data[word] += 1
    end
    data
  end

  private

  attr_reader :source

  def each_word
    source.downcase.scan(/\w+/) do |word|
      yield word
    end
  end

end
