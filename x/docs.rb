%w(help intro track cli).each do |klass|
  require_relative "docs/#{klass}"
end
