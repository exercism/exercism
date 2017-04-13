require 'benchmark'
require 'socket'

class Metrics
  VALID_METRIC_NAME = /\A[a-z_.]+\z/i

  attr_reader :api_key, :host, :port

  def self.time(metric_name, &block)
    new.time(metric_name, &block)
  end

  def self.increment(metric_name)
    new.increment(metric_name)
  end

  def initialize(api_key: ENV['HOSTEDGRAPHITE_APIKEY'], host: 'carbon.hostedgraphite.com', port: 2003)
    @host = host
    @port = port
    return if api_key.blank?
    @api_key = api_key.each_line.first.strip
  end

  def time(metric_name)
    result = nil
    seconds = Benchmark.measure { result = yield }.real
    report(metric_name, seconds)
    result
  end

  def increment(metric_name)
    report(metric_name, 1)
  end

  def report(metric_name, value)
    clean_value = value.to_s.each_line.first.strip
    fail ArgumentError, 'Blank value provided' if clean_value.blank?
    fail ArgumentError, "Invalid metric_name: #{metric_name.inspect}" unless metric_name =~ VALID_METRIC_NAME

    message = "#{api_key}.#{metric_name} #{clean_value}\n"
    if api_key.present?
      UDPSocket.new.send message, 0, host, port
      :sent
    else
      puts "Metric reported: #{message}" unless ENV['RACK_ENV'] == 'test'
      :printed
    end
  end
end
