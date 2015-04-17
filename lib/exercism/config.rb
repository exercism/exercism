class Exercism
  class Config
    def self.tracks
      {
        assembly: 'Assembly Language',
        bash: 'Bash',
        c: 'C',
        clojure: 'Clojure',
        coffeescript: 'CoffeeScript',
        cpp: 'C++',
        csharp: 'C#',
        dlang: 'D',
        ecmascript: 'ECMAScript',
        elixir: 'Elixir',
        erlang: 'Erlang',
        fsharp: 'F#',
        go: 'Go',
        haskell: 'Haskell',
        java: 'Java',
        javascript: 'JavaScript',
        lisp: 'Common Lisp',
        lua: 'Lua',
        nimrod: 'Nimrod',
        :"objective-c" => 'Objective-C',
        ocaml: 'OCaml',
        perl5: 'Perl 5',
        perl6: 'Perl 6',
        php: 'PHP',
        plsql: 'PL/SQL',
        powershell: 'Windows PowerShell',
        proofs: 'Mathematical Proofs',
        python: 'Python',
        r: 'R',
        ruby: 'Ruby',
        rust: 'Rust',
        scala: 'Scala',
        scheme: 'Scheme',
        sml: 'Standard ML',
        swift: 'Swift',
        vbnet: 'VB.NET',
      }
    end

    def self.languages
      @languages ||= tracks.select {|slug, name|
        %i(
          clojure coffeescript csharp cpp elixir erlang
          fsharp go haskell javascript lua lisp objective-c
          ocaml perl5 plsql python ruby scala swift
        ).include?(slug)
      }
    end

    def self.current
      languages.values
    end

    def self.upcoming
      ['D', 'ECMAScript', 'Java', 'Rust', 'PHP'] - current
    end
  end
end
