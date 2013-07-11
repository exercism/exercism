class Words < String

  def count
    data = Hash.new(0)
    each_word do |word|
      data[word] += 1
    end
    data
  end

  private

  def each_word
    downcase.split(/\W+/).each do |word|
      yield word
    end
  end

end
