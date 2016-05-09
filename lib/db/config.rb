require 'erb'
require 'yaml'

module DB
  class Config
    def relative_to_root(*paths)
      File.expand_path(File.join(__FILE__, '..', '..', '..', *paths))
    end

    class UnconfiguredEnvironment < StandardError; end

    attr_reader :file, :environment

    def initialize(environment = default_environment,
                   file = default_database_config)
      @environment = environment
      @file = file
    end

    %i(database host password username port).each do |field|
      define_method(field) { options[field.to_s].to_s }
    end

    def options
      result = YAML.load(yaml)[environment]

      unless result
        error = "No environment '#{environment}' configured in #{file}"
        fail UnconfiguredEnvironment.new(error)
      end

      result
    end

    private

    def default_database_config
      relative_to_root('config', 'database.yml')
    end

    def default_environment
      ENV.fetch('RACK_ENV') { 'development' }
    end

    def yaml
      ERB.new(File.read(file)).result(binding)
    end
  end
end
