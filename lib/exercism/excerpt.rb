class Excerpt
  def initialize(text)
    @html_text = text
  end

  def limit(length)
    text[0..(length - 1)].strip + ellipsis(length)
  end

  private

  def text
    @_raw_text ||= begin
      document = Nokogiri::HTML(@html_text)
      remove_whitespace(document.text)
    end
  end

  def remove_whitespace(string)
    string.split("\n").map(&:strip).join(' ').strip
  end

  def ellipsis(length)
    text.length < length ? '' : '&hellip;'
  end
end
