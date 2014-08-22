class Exercism
  class Config
    def self.languages
      {
        clojure: 'Clojure',
        coffeescript: 'CoffeeScript',
        csharp: 'C#',
        cpp: 'C++',
        elixir: 'Elixir',
        erlang: 'Erlang',
        fsharp: 'F#',
        go: 'Go',
        haskell: 'Haskell',
        javascript: 'JavaScript',
        lua: 'Lua',
        :"objective-c" => 'Objective-C',
        ocaml: 'OCaml',
        perl5: 'Perl5',
        python: 'Python',
        ruby: 'Ruby',
        scala: 'Scala',
        swift: 'Swift',
      }
    end

    def self.current
      languages.values
    end

    def self.upcoming
      ['C++', 'D', 'ECMAScript', 'Java', 'Rust', 'PHP', 'Common Lisp'] - current
    end
  end
end
