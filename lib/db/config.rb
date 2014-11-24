require 'yaml'
require 'erb'

module DB
  class Config
    def relative_to_root(*paths)
      File.expand_path(File.join(__FILE__, '..', '..', '..', *paths))
    end

    class UnconfiguredEnvironment < StandardError; end

    attr_reader :file, :environment
    def initialize(environment, file=default_database_config)
      @environment = environment
      @file = file
    end

    def default_database_config
      relative_to_root('config', 'database.yml')
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
