require_relative '../integration_helper'
require_relative '../../lib/exercism/acl'

class ACLTest < Minitest::Test
  include DBCleaner

  def test_authorize_user_for_problem
    alice = User.create!(username: 'alice')
    grains = Problem.new("go", "grains")

    ACL.authorize(alice, grains)
    assert_equal 1, ACL.count

    # correct values
    acl1 = ACL.first
    assert_equal alice.id, acl1.user_id
    assert_equal "go", acl1.language
    assert_equal "grains", acl1.slug

    # no duplicates, no errors
    ACL.authorize(alice, grains)
    assert_equal 1, ACL.count

    bob = User.create!(username: 'bob')
    leap = Problem.new("elixir", "leap")

    yesterday = 1.day.ago
    acl2 = ACL.create(user_id: bob.id, language: "elixir", slug: "leap", updated_at: yesterday)

    # guard
    acl2.reload
    assert_in_delta 1, acl2.updated_at.to_i, yesterday.to_i

    # updates timestamp correctly
    ACL.authorize(bob, leap)
    acl2.reload

    assert_equal 2, ACL.count
    assert_in_delta 1, acl2.updated_at.to_i, Time.now.utc.to_i
  end
end
