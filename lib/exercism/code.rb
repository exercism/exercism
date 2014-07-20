class Exercism
  class UnknownLanguage < StandardError; end
end

class Code
  LANGUAGES = {
    'clj' => 'clojure',
    'coffee' => 'coffeescript',
    'cpp' => 'cpp',
    'cs' => 'csharp',
    'd' => 'dlang',
    'erl' => 'erlang',
    'exs' => 'elixir',
    'fs' => 'fsharp',
    'go' => 'go',
    'hs' => 'haskell',
    'java' => 'java',
    'js' => 'javascript',
    'lisp' => 'lisp',
    'lua' => 'lua',
    'm' => 'objective-c',
    'ml' => 'ocaml',
    'nim' => 'nimrod',
    'php' => 'php',
    'pl' => 'perl5', # Usually .pl for scripts, .pm for modules, .t for test files
    'pm' => 'perl5',
    'py' => 'python',
    'rb' => 'ruby',
    'rs' => 'rust',
    'scala' => 'scala',
    'swift' => 'swift'
  }

  attr_reader :path
  def initialize(path)
    @path = path
  end

  def filename
    @filename ||= path_segments.last
  end

  def extension
    @extension ||= filename[/([^\.]+)\Z/, 1]
  end

  def slug
    path_segments[1].downcase if path_segments[1]
  end

  def track
    path_segments[0].downcase if path_segments[0]
  end

  private

  def path_segments
    @path_segments ||= path.split(/\/|\\/).reject(&:empty?)
  end
end

