require 'rouge'

module ExercismLib
  class SyntaxHighlighter

    ROUGE_LANG = {
      'objective-c' => 'objective_c',
      'elisp'       => 'common_lisp',
      'plsql'       => 'sql',
      'ecmascript'  => 'javascript',
    }

    attr_reader :lexer, :code

    def initialize(code, track_id)
      language = normalize_language(track_id)
      @lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText

      # XXX HACK: Redcarpet strips hard tabs out of code blocks,
      # so we assume you're not using leading spaces that aren't tabs,
      # and just replace them here.
      @code = code
      @code.gsub!(/^    /, "\t") if lexer.tag == 'make'
    end

    def render
      formatter.format(lexer.lex(code))
    end

    def formatter
      options = {
        css_class:    "highlight #{lexer.tag}",
        line_numbers: true
      }

      Rouge::Formatters::HTML.new(options)
    end

    def normalize_language(language)
      # HACK: Some languages have different names in Rouge
      ROUGE_LANG.fetch(language) { language }
    end
  end
end
