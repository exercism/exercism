class CodeViewer

  def self.make(language, code, line=1, analysis_results=[])
    lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText

    # XXX HACK: Redcarpet strips hard tabs out of code blocks,
    # so we assume you're not using leading spaces that aren't tabs,
    # and just replace them here.
    if lexer.tag == 'make'
      code.gsub! /^    /, "\t"
    end

    formatter = AnalysisFormatter.new({:css_class => "highlight #{lexer.tag}", :line_numbers => true, :start_line => line},
                                      analysis_results)
    formatter.format(lexer.lex(code))
  end

end