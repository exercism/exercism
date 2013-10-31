require 'yaml'
require 'erb'

module DB
  class Config
    class UnconfiguredEnvironment < StandardError; end

    attr_reader :file, :environment
    def initialize(environment, file='./config/database.yml')
      @environment = environment
      @file = file
    end

    def options
      result = YAML.load(yaml)[environment]
      unless result
        error = "No environment '#{environment}' configured in #{file}"
        raise UnconfiguredEnvironment.new(error)
      end
      result
    end

    def yaml
      if ENV['RACK_ENV'] == 'production'
        ERB.new(File.read(file)).result binding
      else
        File.read(file)
      end
    end
  end

end
