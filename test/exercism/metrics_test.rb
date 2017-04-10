require_relative '../test_helper'
require 'active_support'
require 'active_support/core_ext/object'
require 'exercism/metrics'
require 'mocha/setup'

class MetricsTest < MiniTest::Test
  def test_reports_without_error
    metrics = Metrics.new(api_key: 'test', host: 'localhost')
    UDPSocket.any_instance.expects(:send).twice
    metrics.time('test.time') { 1 }
    metrics.increment('test.count')
  end

  def test_continues_gracefully_without_api_key
    prior_value = ENV.delete 'HOSTEDGRAPHITE_APIKEY'
    Metrics.time('test.time') { 1 }
    Metrics.increment('test.count')
    ENV['HOSTEDGRAPHITE_APIKEY'] = prior_value if prior_value
  end

  def test_refuses_invalid_metric_key_names
    assert_raises(ArgumentError) do
      metrics = Metrics.new(api_key: 'test', host: 'localhost')
      metrics.increment('nonstandard-hyphenated-key')
    end
  end
end
