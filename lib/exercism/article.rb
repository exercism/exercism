class Article
  attr_reader :text, :substitutions
  def initialize(text, substitutions={})
    @text = text
    @substitutions = substitutions
  end

  def to_s
    s = text
    substitutions.each do |placeholder, substitution|
      s = s.gsub "{{#{placeholder}}}", substitution
    end
    s
  end

  def to_html
    ConvertsMarkdownToHTML.convert(to_s)
  end
end
