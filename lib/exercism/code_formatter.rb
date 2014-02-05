require 'exercism/converts_markdown_to_html'

class CodeFormatter

  def self.format(code, lang)
    html_content = ConvertsMarkdownToHTML.convert("```#{lang}\n#{code}\n```")
    dom = Nokogiri::HTML(html_content)
    html_lines = dom.css("td[class='code'] pre").first.children.to_s.chomp.split("\n")

    rows = html_lines.each_with_index.map { |line, no| "<tr><td class=\"lineno\">#{no + 1}</td><td>#{line}</tr></td>\n" }

    # TODO: lang can be anything, fix potential xss
    "<table class=\"code-table highlight #{lang}\">\n#{rows.join}</table>"
  end

end
