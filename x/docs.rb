%w(help track).each do |klass|
  require_relative "docs/#{klass}"
end
