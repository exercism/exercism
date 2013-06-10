class Words

  attr_reader :text
  def initialize(text)
    @text = text.downcase.gsub(/[^a-z0-9\s]/, '')
  end

  def count
    data = Hash.new(0)
    text.split(" ").each do |word|
      data[word] += 1
    end
    data
  end
end
