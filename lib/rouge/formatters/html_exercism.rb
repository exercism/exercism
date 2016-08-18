require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTMLExercism < Formatter
      tag 'html'

      # @option opts [String] :css_class ('highlight')
      #
      # Content will be wrapped in a `div` tag with the given `:css_class`
      def initialize(opts={})
        @css_class = %( class="#{opts.fetch(:css_class, 'highlight')}")
        @html_formatter = Rouge::Formatters::HTML.new
      end

      def stream(tokens, &b)
        yield "<div#{@css_class}>"
        stream_code(tokens, &b)
        yield "</div>\n"
      end

      def stream_code(tokens, &b)
        code_lines = token_lines(tokens)

        yield '<table style="border-spacing: 0"><tbody><tr>'

        yield numbered_gutter(1..code_lines.count)

        yield '<td class="code">'
        yield '<pre>'
        format_code(code_lines, &b)
        yield '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
      end

      private

      def format_code(code_lines)
        code_lines.each.with_index do |line, index|
          yield %(<span id="#{css_line_id(index + 1)}">)
          line.each do |tok, val|
            yield @html_formatter.span(tok, val)
          end
          yield %(\n</span>)
        end
      end

      def numbered_gutter(number_range)
        # the "gl" class applies the style for Generic.Lineno
        '<td class="gutter gl" style="text-align: right">' <<
          '<pre class="lineno">%s</pre>' % line_number_links(number_range).join("\n") <<
          '</td>'
      end

      def line_number_links(number_range)
        number_range.map do |number|
          %(<a href="##{css_line_id(number)}">#{number}</a>)
        end
      end

      def css_line_id(number)
        "L#{number}"
      end
    end
  end
end
