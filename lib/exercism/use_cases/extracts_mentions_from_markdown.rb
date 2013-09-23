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
    @mentions = []
    candidates.each do |username|
      @mentions << User.where(username: username.sub(/\@/, '')).first rescue nil
    end
  end

  private

  def candidates
    html_content_without_code.scan(/\@\w+/).uniq
  end

  def html_content_without_code
    html_content = Markdown.render(@content)
    dom = Nokogiri::HTML(html_content)
    dom.css("code").remove
    dom.css("td[class='code']").remove
    body = dom.css("body").first
    body ? body.content : ""
  end

end
