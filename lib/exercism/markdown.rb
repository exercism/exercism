require 'redcarpet'
require 'nokogiri'
require 'exercism/syntax_highlighter'

# GitHub usernames can contain alphanumerics and dashes, but must not
# start with a dash.
USERNAME_REGEX = /(@[0-9a-zA-z][0-9a-zA-Z\-]*)/

# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
def hyperlink_mentions!(node)
  node.children.each do |child|
    if child.node_type == Nokogiri::XML::Node::ELEMENT_NODE &&
       !child.matches?('code,td[class=code]')
      hyperlink_mentions! child
    elsif child.node_type == Nokogiri::XML::Node::TEXT_NODE
      set = []
      remaining = child.content
      until remaining.empty?
        head, match, remaining = remaining.partition(USERNAME_REGEX)
        set << child.document.create_text_node(head)
        next if match.empty?
        link = child.document.create_element("a")
        link.set_attribute('class', 'mention')
        link.set_attribute('href', '/' + match[1..-1])
        link.content = match
        set << link
      end
      if set.length > 1
        set = Nokogiri::XML::NodeSet.new(child.document, set)
        child.replace(set)
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

module ExercismLib
  class Markdown < Redcarpet::Render::XHTML
    def self.render(content)
      markdown = Redcarpet::Markdown.new(new, options)
      markdown.render(content)
    end

    # rubocop:disable Metrics/MethodLength
    def self.options
      {
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        autolink: true,
        strikethrough: true,
        lax_html_blocks: true,
        superscript: true,
        tables: true,
        space_after_headers: true,
        xhtml: true,
      }
    end
    # rubocop:enable Metrics/MethodLength

    def preprocess(text_content)
      # patch while redcarpet doesn't support lists without newline issue#2759
      # captures line before list and adds another newline
      text_content.gsub(/^\w+\n(?=[*|-]\s\w+)/, "\\0\n")
    end

    def postprocess(html_content)
      dom = Nokogiri::HTML(html_content)
      body = dom.css("body").first
      if body
        hyperlink_mentions! body
        return body.inner_html
      end
      ""
    end

    def block_code(code, language)
      ExercismLib::SyntaxHighlighter.new(code, language).render
    end
  end
end
