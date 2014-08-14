class Language
  def self.of(key)
    all[key.to_sym]
  end

  def self.all
    {
      clojure: 'Clojure',
      coffeescript: 'CoffeeScript',
      cpp: 'C++',
      csharp: 'C#',
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
end
