%w(todo exercise).each do |klass|
  require_relative "todos/#{klass}"
end
