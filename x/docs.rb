%w(help intro cli track).each do |klass|
  require_relative "docs/#{klass}"
end
