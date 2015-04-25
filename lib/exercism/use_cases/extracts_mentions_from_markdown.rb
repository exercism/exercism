class ExtractsMentionsFromMarkdown

  attr_reader :mentions

  def self.extract(content)
    extractor = new(content)
    extractor.extract
    extractor.mentions
  end

  def initialize(content)
    @content = content
  end

  def extract
    @mentions = User.where(username: candidates)
  end

  private

  def candidates
    html_content_without_code.scan(/\@(\w+)/).uniq.flatten
  end

  def html_content_without_code
    html_content = ExercismLib::Markdown.render(@content)
    dom = Nokogiri::HTML(html_content)
    dom.css("code").remove
    dom.css("td[class='code']").remove
    body = dom.css("body").first
    body ? body.content : ""
  end

end
