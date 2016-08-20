require 'rouge'
require 'rouge/formatters/html_exercism'

module ExercismLib
  class SyntaxHighlighter
    ROUGE_LANG = {
      'objective-c' => 'objective_c',
      'elisp'       => 'common_lisp',
      'lisp'        => 'common_lisp',
      'lfe'         => 'common_lisp',
      'plsql'       => 'sql',
      'ecmascript'  => 'javascript',
      'perl5'       => 'perl',
      'crystal'     => 'ruby',
    }.freeze

    attr_reader :lexer, :code

    def initialize(code, track_id)
      language = normalize_language(track_id)
      code     = normalize_newlines(code)

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
      Rouge::Formatters::HTMLExercism.new(css_class: "highlight #{lexer.tag}")
    end

    def normalize_language(language)
      # HACK: Some languages have different names in Rouge
      ROUGE_LANG.fetch(language) { language }
    end

    def normalize_newlines(code)
      code.gsub(/\r\n?/, "\n")
    end
  end
end
