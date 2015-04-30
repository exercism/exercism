require_relative '../integration_helper'

class CohortTest < Minitest::Test
  include DBCleaner

  def test_team_members_and_managers
    alice = User.create username: 'alice'
    bob = User.create username: 'bob'
    charlie = User.create username: 'charlie'
    dave = User.create username: 'dave'
    eve = User.create username: 'eve'

    Submission.create(language: 'ruby', slug: 'cake', code: 'CODE', user: charlie)
    Submission.create(language: 'ruby', slug: 'cake', code: 'CODE', user: dave, state: 'done')

    team1 = Team.by(alice).defined_with(slug: 'team1', users: [bob, charlie], inviter: alice)
    team1.save
    team2 = Team.by(alice).defined_with(slug: 'team2', users: [bob, dave, eve], inviter: alice)
    team2.save

    team1.confirm(bob.username)
    team2.confirm(bob.username)

    problem = Problem.new('ruby', 'cake')

    cohort = Cohort.for(bob)
    assert_equal [], cohort.members.map(&:username)
    assert_equal ['alice'], cohort.managers.map(&:username)
    assert_equal ['alice'], cohort.team_members_and_managers.map(&:username)
    assert_equal ['alice'], cohort.sees(problem).map(&:username)

    team2.confirm(dave.username)
    team2.confirm(eve.username)

    bob.reload
    cohort = Cohort.for(bob)

    assert_equal %w(dave eve), cohort.members.map(&:username).sort
    assert_equal ['alice'], cohort.managers.map(&:username).sort
    assert_equal %w(alice dave eve), cohort.team_members_and_managers.map(&:username).sort
    assert_equal %w(alice dave), cohort.sees(problem).map(&:username).sort
  end

end

