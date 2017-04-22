%w(help intro cli launch).each do |klass|
  require_relative "docs/#{klass}"
end
