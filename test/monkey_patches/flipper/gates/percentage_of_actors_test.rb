require_relative '../../../test_helper'
require 'ostruct'
require 'monkey_patches/flipper/gates/percentage_of_actors'
require 'mocha/mini_test'

class FlipperPercentageOfActorsTest < Minitest::Test
  def test_control_group_consistent_across_features
    50.times do |user_id|
      github_username = "user#{user_id}"
      actor = OpenStruct.new(flipper_id: github_username)
      base_case_enabled = enabled_for?(actor, :base_feature)
      50.times do |feature_id|
        feature = "feature_#{feature_id}"
        assert_equal base_case_enabled, enabled_for?(actor, feature)
      end
    end
  end

  def enabled_for?(actor, feature_id)
    context = OpenStruct.new(
      values: {percentage_of_actors: 50},
      thing: actor,
      feature_name: "feature#{feature_id}"
    )
    gate = Flipper::Gates::PercentageOfActors.new
    gate.open?(context)
  end
end
