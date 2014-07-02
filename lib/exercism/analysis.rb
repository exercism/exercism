AnalyzerConfig = Struct.new(:adapter, :analyzers)

ANALYZER_CONFIG = {
    'ruby' => AnalyzerConfig.new(Exercism::Adapters::Ruby, [Exercism::Analyzers::ForLoop]),
}

ANALYZER_MESSAGES = {
    for_loop: 'Rubyists generally prefer to use enumerables (e.g. each) rather than a for loop',
}

TOOLTIP_MESSAGES = {
    for_loop: 'For loop detected'
}