require 'redcarpet'
require 'nokogiri'
require 'rouge'
require 'rouge/plugins/redcarpet'

# GitHub usernames can contain alphanumerics and dashes, but must not
# start with a dash.
USERNAME_REGEX = /(@[0-9a-zA-z][0-9a-zA-Z\-]*)/

def hyperlink_mentions!(node)
  node.children.each do |child|
    if child.node_type == Nokogiri::XML::Node::ELEMENT_NODE and
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

class Markdown < Redcarpet::Render::XHTML

  def self.render(content, analysis_results=[])
    renderer = new(renderer_options, analysis_results)
    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(content)
  end

  def initialize(render_options, analysis_results=[])
    super(render_options)
    @analysis_results = analysis_results
  end

  def self.renderer_options
    {
      hard_wrap: true
    }
  end

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
      xhtml: true
    }
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
    CodeViewer.make(language, code, 1, @analysis_results)
  end

end
