require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTMLExercism < Formatter
      tag 'html'

      attr_reader :num_lines

      # @option opts [String] :css_class ('highlight')
      # @option opts [true/false] :line_numbers (false)
      # @option opts [String] :line_numbers_id ('L')
      # @option opts [Rouge::CSSTheme] :inline_theme (nil)
      # @option opts [true/false] :wrap (true)
      #
      # Initialize with options.
      #
      # If `:inline_theme` is given, then instead of rendering the
      # tokens as <span> tags with CSS classes, the styles according to
      # the given theme will be inlined in "style" attributes.  This is
      # useful for formats in which stylesheets are not available.
      #
      # Content will be wrapped in a tag (`div` if tableized, `pre` if
      # not) with the given `:css_class` unless `:wrap` is set to `false`.
      def initialize(opts={})
        @css_class = opts.fetch(:css_class, 'highlight')
        @css_class = " class=#{@css_class.inspect}" if @css_class

        @line_numbers = opts.fetch(:line_numbers, false)
        @line_numbers_id = opts.fetch(:line_numbers_id, 'L')
        @start_line = opts.fetch(:start_line, 1)
        @inline_theme = opts.fetch(:inline_theme, nil)
        @inline_theme = Theme.find(@inline_theme).new if @inline_theme.is_a? String

        @wrap = opts.fetch(:wrap, true)

        @html_formatter = Rouge::Formatters::HTML.new
      end

      def stream(tokens, &b)
        @num_lines = token_lines(tokens).count

        if @line_numbers
          stream_tableized(tokens, &b)
        else
          stream_untableized(tokens, &b)
        end
      end

      def stream_untableized(tokens, &b)
        yield "<pre#{@css_class}><code>" if @wrap
        tokens.each { |tok, val| span(tok, val, &b) }
        yield "</code></pre>\n" if @wrap
      end

      def stream_tableized(tokens, &b)
        yield "<div#{@css_class}>" if @wrap
        yield '<table style="border-spacing: 0"><tbody><tr>'

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl" style="text-align: right">' << gutter << '</td>'

        yield '<td class="code">'
        yield '<pre>'
        format_code(tokens, &b)
        yield '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
        yield "</div>\n" if @wrap
      end

      private

      def format_code(tokens)
        # Very similar to Rouge::Formatters::HTMLLinewise#stream, which is not customizable enough
        token_lines(tokens) do |line|
          yield next_line
          line.each do |tok, val|
            yield @html_formatter.span(tok, val)
          end
          yield end_line
        end
      end

      def next_line
        @lineno ||= @start_line - 1
        %(<span id="#{@line_numbers_id}#{@lineno += 1}">)
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
          "<a href=\"##{@line_numbers_id}#{number}\">#{number}</a>"
        end
      end
    end
  end
end
