AnalyzerConfig = Struct.new(:adapter, :analyzers)

ANALYZER_CONFIG = {
    'ruby' => AnalyzerConfig.new(Exercism::Adapters::Ruby, [Exercism::Analyzers::ForLoop, Exercism::Analyzers::IterMutation]),
}

ANALYZER_MESSAGES = {
    for_loop: 'Rubyists generally prefer to use enumerables (e.g. each) rather than a for loop',
    iter_mutation: 'Rubyists generally prefer to use select when filtering a collection'
}

TOOLTIP_MESSAGES = {
    for_loop: 'For loop detected',
    iter_mutation: 'Mutation within block detected'
}