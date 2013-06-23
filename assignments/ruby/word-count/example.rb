class Words

  attr_reader :phrase
  def initialize(text)
    @phrase = text.downcase.gsub(/[^a-z0-9\s]/, '').split(' ')
  end

  def count
    data = Hash.new(0)
    each_word do |word|
      data[word] += 1
    end
    data
  end

  private

  def each_word
    phrase.each do |word|
      yield word
    end
  end

end
