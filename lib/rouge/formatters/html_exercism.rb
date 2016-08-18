require 'cgi'

module Rouge
  module Formatters
    # Transforms a token stream into HTML output.
    class HTMLExercism < Formatter
      tag 'html'

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
      end

      # @yield the html output.
      def stream(tokens, &b)
        if @line_numbers
          stream_tableized(tokens, &b)
        else
          stream_untableized(tokens, &b)
        end
      end

      private

      def stream_untableized(tokens, &b)
        yield "<pre#{@css_class}><code>" if @wrap
        tokens.each { |tok, val| span(tok, val, &b) }
        yield "</code></pre>\n" if @wrap
      end

      def stream_tableized(tokens)
        num_lines = count_newlines(tokens)

        yield "<div#{@css_class}>" if @wrap
        yield '<table style="border-spacing: 0"><tbody><tr>'

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl" style="text-align: right">' << gutter(num_lines) << '</td>'

        yield '<td class="code">'
        yield '<pre>' << formatted_code(tokens, @start_line) << '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
        yield "</div>\n" if @wrap
      end

      TABLE_FOR_ESCAPE_HTML = {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
      }.freeze

      def span(tok, val)
        val = html_escaped(val)
        shortname = tok.shortname or fail "unknown token: #{tok.inspect} for #{val.inspect}"
        if shortname.empty?
          yield val
        elsif @inline_theme
          rules = @inline_theme.style_for(tok).rendered_rules
          yield "<span style=\"#{rules.to_a.join(';')}\">#{val}</span>"
        else
          yield "<span class=\"#{shortname}\">#{val}</span>"
        end
      end

      def start_line(num)
        %(<span id="L#{num}">)
      end

      def end_line
        "</span>"
      end

      def line_numbers(num_lines)
        # wrap line numbers with <a> tags
        (@start_line..num_lines + @start_line - 1).map do |number|
          "<a href=\"#L#{number}\">#{number}</a>"
        end
      end

      def gutter(num_lines)
        # generate a string of newline-separated line numbers for the gutter>
        %(<pre class="lineno">#{line_numbers(num_lines).join("\n")}</pre>)
      end

      def html_escaped(text)
        text.gsub(/[&<>]/, TABLE_FOR_ESCAPE_HTML)
      end

      def formatted_code(tokens, line_counter)
        # Reuse argument as line counter
        formatted = start_line(line_counter)

        tokens.each do |tok, val|
          # Some tokens span multiple lines, such as Python triplequoted strings, or
          # delimited comments in other languages.
          val.lines.each do |line|
            # Wrap each line of this token in the same class
            span(tok, line) { |str| formatted << str }

            # Increase line number only when the actual token text contained a newline
            next unless line.include? "\n"
            line_counter += 1
            formatted << end_line << start_line(line_counter)
          end
        end
        adjust_final_lines formatted, line_counter
      end

      def adjust_final_lines(formatted, line_counter)
        formatted << end_line
        formatted.gsub final_blank_line(line_counter), ''
      end

      def count_newlines(tokens)
        tokens.inject(0) { |acc, (_, val)| acc + val.scan("\n").size }
      end

      def final_blank_line(counter)
        start_line(counter) + end_line
      end
    end
  end
end
