require_relative '../test_helper'
require 'bugsnag'
require './config/bugsnag'
require 'exercism/named'
require_relative '../x_helper'
require 'exercism/problem'
require 'exercism/successor'

class SuccessorTest < Minitest::Test
  def test_params

    tests = [
      [{inbox: 'go'}, {i: '1'}, "?language=go"],
      [{inbox: 'go', inbox_slug: 'hamming'}, {i: '1'}, "?language=go&slug=hamming"],
      [{inbox: 'go'}, {}, "?language=ruby&slug=leap"],
      [{inbox: 'go', inbox_slug: 'hamming'}, {}, "?language=ruby&slug=leap"],
    ]

    tests.each.with_index do |(session, params, expected), i|
      succ = Successor.from(session, params, Problem.new('ruby', 'leap'))
      assert_equal expected, succ.to_params, "case: %d" % i
    end
  end
end

