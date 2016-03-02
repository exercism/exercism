require 'commonmarker'
require 'nokogiri'

require 'exercism/syntax_highlighter'

# GitHub usernames can contain alphanumerics and dashes, but must not
# start with a dash.
USERNAME_REGEX = /(@[0-9a-zA-z][0-9a-zA-Z\-]*)/

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
        unless match.empty?
          link = child.document.create_element("a")
          link.set_attribute('class', 'mention')
          link.set_attribute('href', '/' + match[1..-1])
          link.content = match
          set << link
        end
      end
      if set.length > 1
        set = Nokogiri::XML::NodeSet.new(child.document, set)
        child.replace(set)
      end
    end
  end
end

module ExercismLib

  class Markdown

    def self.render(content)
      @myrenderer = MyHtmlRenderer.new
      doc = CommonMarker.render_doc(content, :default)
      postprocess(@myrenderer.render(doc))
    end

    def self.postprocess(html_content)
      dom = Nokogiri::HTML(html_content)
      body = dom.css("body").first
      if body
        hyperlink_mentions! body
        return body.inner_html
      end
      ""
    end

  end

end

class MyHtmlRenderer < CommonMarker::HtmlRenderer
  def code_block(node)
    block do
      out(ExercismLib::SyntaxHighlighter.new(node.string_content, node.fence_info.split(/\s+/)[0]).render)
    end
  end
end
