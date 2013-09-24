class ExtractsMentionsFromMarkdown

  attr_reader :mentions

  def self.extract(content)
    return [] if content.empty?
    extracter = new(content)
    extracter.extract
    extracter.mentions
  end

  def initialize(content)
    @content = content
  end
  
  def extract
    @mentions = []
    candidates.each do |username|
      @mentions << User.find_by(u: username.sub(/\@/, '')) rescue nil
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
    dom.css("body").first.content
  end

end
