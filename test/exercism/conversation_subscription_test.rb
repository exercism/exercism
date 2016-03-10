require_relative '../integration_helper'
require 'minitest/pride'

# just for the tests, don't need this method in production
class ConversationSubscription < ActiveRecord::Base
  def self.for(user, iteration)
    where(user_id: user.id, solution_id: iteration.user_exercise_id).first
  end
end

class ConversationSubscriptionTest < Minitest::Test
  include DBCleaner

  def test_join_vs_unsubscribe
    alice = User.create!(username: 'alice')
    iteration = Submission.create!(user_id: alice.id, user_exercise_id: 1)

    [
      [:join, true, "join a conversation"],
      [:join, true, "don't create duplicate subscription"],
      [:unsubscribe, false, "unsubscribe explicitly"],
      [:join, false, "don't subscribe if explicitly unsubscribed"],
    ].each do |method, subscribed, desc|
      ConversationSubscription.send(method, alice, iteration)

      assert_equal 1, ConversationSubscription.count, desc
      assert_equal subscribed, ConversationSubscription.for(alice, iteration).subscribed, desc
    end

    bob = User.create!(username: 'bob')
    [
      [:subscribe, true, "explicitly subscribe to a conversation"],
      [:subscribe, true, "don't create duplicate subscription"],
      [:unsubscribe, false, "unsubscribe explicitly"],
      [:subscribe, true, "explicitly resubscribe"],
    ].each do |method, subscribed, desc|
      ConversationSubscription.send(method, bob, iteration)

      assert_equal 2, ConversationSubscription.count, desc
      assert_equal subscribed, ConversationSubscription.for(bob, iteration).subscribed, desc
    end

    charlie = User.create!(username: 'charlie')
    # Unsubscribe explicitly without a subscription. It shouldn't blow up.
    ConversationSubscription.unsubscribe(charlie, iteration)
  end
end
