require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTMLExercism < Formatter
      tag 'html'

      attr_reader :num_lines
      LINE_NUMBERS_ID = 'L'.freeze

      # @option opts [String] :css_class ('highlight')
      # @option opts [true/false] :wrap (true)
      # @option opts [Number] :start_line
      #
      # Initialize with options.
      #
      # Content will be wrapped in a `div` tag with the given `:css_class`
      # unless `:wrap` is set to `false`. If `:start_line` is given,
      # line numbering will start at that number instead of 1.
      def initialize(opts={})
        @css_class = opts.fetch(:css_class, 'highlight')
        @css_class = " class=#{@css_class.inspect}" if @css_class

        @start_line = opts.fetch(:start_line, 1)
        @wrap = opts.fetch(:wrap, true)

        @html_formatter = Rouge::Formatters::HTML.new
      end

      def stream(tokens, &b)
        @num_lines = token_lines(tokens).count

        yield "<div#{@css_class}>" if @wrap
        stream_code(tokens, &b)
        yield "</div>\n" if @wrap
      end

      def stream_code(tokens, &b)
        yield '<table style="border-spacing: 0"><tbody><tr>'

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl" style="text-align: right">' << gutter << '</td>'

        yield '<td class="code">'
        yield '<pre>'
        format_code(tokens, &b)
        yield '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
      end

      private

      def format_code(tokens)
        # Very similar to Rouge::Formatters::HTMLLinewise#stream, which is not customizable enough
        token_lines(tokens) do |line|
          yield start_line
          line.each do |tok, val|
            yield @html_formatter.span(tok, val)
          end
          yield end_line
        end
      end

      def start_line
        @lineno ||= @start_line - 1
        %(<span id="#{LINE_NUMBERS_ID}#{@lineno += 1}">)
      end

      def end_line
        # NOTE: the newline is for test compatibility.
        # It's unnecessary for presentation if we use divs instead (and display: block for lines)
        "\n</span>"
      end

      def gutter
        %(<pre class="lineno">#{line_numbers.join("\n")}</pre>)
      end

      def line_numbers
        (@start_line..num_lines + @start_line - 1).map do |number|
          "<a href=\"##{LINE_NUMBERS_ID}#{number}\">#{number}</a>"
        end
      end
    end
  end
end
