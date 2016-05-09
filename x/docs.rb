%w(help intro track cli launch).each do |klass|
  require_relative "docs/#{klass}"
end
