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
        yield "<pre#@css_class><code>" if @wrap
        tokens.each{ |tok, val| span(tok, val, &b) }
        yield "</code></pre>\n" if @wrap
      end

      def stream_tableized(tokens)
        num_lines = 0
        last_val = ''
        formatted = ''

        tokens.each do |tok, val|
          last_val = val
          num_lines += val.scan(/\n/).size
          span(tok, val) { |str| formatted << str }
        end

        formatted = formatted.lines.map.with_index(1) do |line, index|
          "<span id='#{@line_numbers_id}#{index}'>#{line}</span>"
        end.join

        # add an extra line for non-newline-terminated strings
        if last_val[-1] != "\n"
          num_lines += 1
          span(Token::Tokens::Text::Whitespace, "\n") { |str| formatted << str }
        end

        # wrap line numbers with <a> tags
        line_numbers = (@start_line..num_lines+@start_line-1).map do |number|
          "<a href=\"#L#{number}\">#{number}</a>"
        end

        # generate a string of newline-separated line numbers for the gutter>
        gutter = %<<pre class="lineno">#{line_numbers.join("\n")}</pre>>

        yield "<div#@css_class>" if @wrap
        yield '<table style="border-spacing: 0"><tbody><tr>'

        # the "gl" class applies the style for Generic.Lineno
        yield '<td class="gutter gl" style="text-align: right">'
        yield gutter
        yield '</td>'

        yield '<td class="code">'
        yield '<pre>'
        yield formatted
        yield '</pre>'
        yield '</td>'

        yield "</tr></tbody></table>\n"
        yield "</div>\n" if @wrap
      end

      TABLE_FOR_ESCAPE_HTML = {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
      }

      def span(tok, val)
        val = val.gsub(/[&<>]/, TABLE_FOR_ESCAPE_HTML)
        shortname = tok.shortname or raise "unknown token: #{tok.inspect} for #{val.inspect}"

        if shortname.empty?
          yield val
        else
          if @inline_theme
            rules = @inline_theme.style_for(tok).rendered_rules

            yield "<span style=\"#{rules.to_a.join(';')}\">#{val}</span>"
          else
            yield "<span class=\"#{shortname}\">#{val}</span>"
          end
        end
      end
    end
  end
end
