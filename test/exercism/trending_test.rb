require_relative '../integration_helper'

class TrendingTest < Minitest::Test
  include DBCleaner

  # TODO: exclude archived exercises
  def test_trending_only_returns_recent_activity
    alice = User.create(username: 'alice')
    fred = User.create(username: 'fred')

    %w(bob leap).each do |slug|
      ACL.authorize(alice, Problem.new('ruby', slug))
    end

    s1 = Submission.create!(user: alice, language: 'ruby', slug: 'bob', created_at: 22.days.ago) # recently liked
    s2 = Submission.create!(user: fred, language: 'ruby', slug: 'bob', created_at: 10.days.ago) # recently commented
    s3 = Submission.create!(user: fred, language: 'ruby', slug: 'leap', created_at: 10.days.ago) # old comment

    Like.create!(submission: s1, user: fred)
    Comment.create!(submission: s2, user: fred, body: ' hope that after I die, people will say of me: "That guy sure owed me a lot of money."')
    Comment.create!(submission: s3, user: fred, body: 'If you ever drop your keys into a river of molten lava, let em go, because, man, theyre gone.', created_at: Time.now - 12.hours)

    uuids = Trending.for(alice, 4.hours).map(&:uuid)
    assert_equal [s1.key, s2.key].sort, uuids.sort
  end
end
