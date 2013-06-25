class Words

  attr_reader :phrase
  def initialize(text)
    @phrase = normalize(text)
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

  def normalize(text)
    text.downcase.gsub(/\W/, ' ').split(' ')
  end

end
