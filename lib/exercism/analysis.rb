AnalyzerConfig = Struct.new(:adapter, :analyzers)

ANALYZER_CONFIG = {
    'ruby' => AnalyzerConfig.new(Exercism::Adapters::Ruby, [Exercism::Analyzers::Roodi]),
    'python' => AnalyzerConfig.new(Exercism::Adapters::Python, [Exercism::Analyzers::Pylint]),
    'javascript' => AnalyzerConfig.new(Exercism::Adapters::Javascript, [Exercism::Analyzers::Jslint]),
    'go' => AnalyzerConfig.new(Exercism::Adapters::Go, [Exercism::Analyzers::Golint]),
    'clojure' => AnalyzerConfig.new(Exercism::Adapters::Clojure, [Exercism::Analyzers::Kibit]),
}