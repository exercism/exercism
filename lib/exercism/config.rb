class Exercism
  class Config
    def self.languages
      [
        :clojure,
        :coffeescript,
        :elixir,
        :go,
        :haskell,
        :javascript,
        :"objective-c",
        :ocaml,
        :perl5,
        :python,
        :ruby,
        :scala,
      ]
    end

    def self.current
      languages.map {|language| language.to_s.split('-').map(&:capitalize).join(' ')}.sort
    end

    def self.upcoming
      ['Java', 'Rust', 'Erlang', 'PHP', 'Common Lisp'] - current
    end
  end
end
