$LOAD_PATH.unshift File.expand_path("./../lib", __FILE__)
Dir.glob("lib/tasks/*.rake").each { |r| import r }

task default: %w(test:everything)
