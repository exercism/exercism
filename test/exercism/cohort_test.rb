require './test/integration_helper'

class CohortTest < MiniTest::Unit::TestCase
  include DBCleaner

  def test_team_members_and_managers
    alice = User.create username: 'alice'
    bob = User.create username: 'bob'
    charlie = User.create username: 'charlie'
    dave = User.create username: 'dave'
    eve = User.create username: 'eve'

    Submission.create(language: 'ruby', slug: 'cake', code: 'CODE', user: charlie)
    Submission.create(language: 'ruby', slug: 'cake', code: 'CODE', user: dave, state: 'done')

    team1 = Team.create(slug: 'team1', unconfirmed_members: [bob, charlie], creator: alice)
    team2 = Team.create(slug: 'team2', unconfirmed_members: [bob, dave, eve], creator: alice)

    team1.confirm(bob.username)
    team2.confirm(bob.username)

    assert_equal Set.new, Cohort.for(alice).users

    exercise = Exercise.new('ruby', 'cake')

    cohort = Cohort.for(bob)
    assert_equal [], cohort.members.map(&:username)
    assert_equal ['alice'], cohort.managers.map(&:username)
    assert_equal ['alice'], cohort.users.map(&:username).sort
    assert_equal ['alice'], cohort.sees(exercise).map(&:username)

    team2.confirm(dave.username)
    team2.confirm(eve.username)

    bob.reload
    cohort = Cohort.for(bob)

    assert_equal %w(dave eve), cohort.members.map(&:username)
    assert_equal ['alice'], cohort.managers.map(&:username)
    assert_equal %w(alice dave eve), cohort.users.map(&:username).sort
    assert_equal %w(alice dave), cohort.sees(exercise).map(&:username)
  end

end

