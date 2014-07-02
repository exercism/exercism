class AnalysisFormatter < Rouge::Formatters::HTML

  TEMPLATE = <<-TEMPLATE
<div%s>
  <table style="border-spacing: 0">
    <tbody>
      <tr>
        <td class="gutter gl" style="text-align: center">
          <pre class="lineno">%s</pre>
        </td>
        <td class="code">
          <pre>%s</pre>
        </td>
      </tr>
    </tbody>
  </table>
</div>
  TEMPLATE
  GUTTER = <<-GUTTER.chomp
<a href="#feedback%s" class="warning" data-toggle="tooltip" data-placement="top" title="%s">%s</a>
  GUTTER

  def initialize(opts={}, analysis_results=[])
    super(opts)
    @analysis_results = analysis_results
  end

  def stream_tableized(tokens)
    line = @start_line
    last_val = ''
    formatted = ''

    tokens.each do |tok, val|
      last_val = val
      span(tok, val) { |str| formatted << str }
      line += val.scan(/\n/).size
    end

    # add an extra line for non-newline-terminated strings
    if last_val[-1] != "\n"
      line += 1
      span(Rouge::Token::Tokens::Text::Whitespace, "\n") { |str| formatted << str }
    end

    gutter = (@start_line..line.pred).to_a.map(&method(:gutter_warning)).join("\n")
    yield TEMPLATE % [@css_class, gutter, formatted]
  end

  def gutter_warning(line)
    if result = @analysis_results.find {|r| r.feedback.find {|f| f.line == line } }
      tooltip = "#{TOOLTIP_MESSAGES[result.type]}. Click to see example"
      GUTTER % [line, tooltip, line]
    else
      line
    end
  end

end