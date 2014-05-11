class Exercism
  class Config
    def self.languages
      {
        clojure: 'Clojure',
        coffeescript: 'CoffeeScript',
        csharp: 'C#',
        elixir: 'Elixer',
        go: 'Go',
        haskell: 'Haskell',
        javascript: 'JavaScript',
        :"objective-c" => 'Objective-C',
        ocaml: 'OCaml',
        perl5: 'Perl5',
        python: 'Python',
        ruby: 'Ruby',
        scala: 'Scala',
      }
    end

    def self.current
      languages.each_value.to_a
    end

    def self.upcoming
      ['Java', 'Rust', 'Erlang', 'PHP', 'Common Lisp'] - current
    end
  end
end
