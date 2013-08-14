require './test/integration_helper'

class PendingWorkloadTest < Minitest::Test
  def submission(options = {})
    options = {language: 'ruby', slug: 'bob'}.merge(options)
    Submission.create(options)
  end

  def user(username, options = {})
    options = {
      username: username,
      current: {'ruby' => 'bob'}
    }.merge(options)
    User.create(options)
  end

  attr_reader :bob, :charlie, :dave, :eve, :fred,
    :s0, :s1, :s2, :s3, :s4, :s5, :s6, :s7
  def setup
    @bob = user('bob', current: {'ruby' => 'bob', 'python' => 'bob'})
    @charlie = user('charlie', current: {'ruby' => 'word-count', 'python' => 'word-count'}, completed: {'ruby' => ['word-count'], 'python' => ['bob']})
    @dave = user('dave')
    @eve = user('eve')
    @fred = user('fred')

    assert_equal 0, Submission.count # guard clause

    # not pending
    @s0 = submission(user: bob, state: 'superseded')

    # pending, in python
    @s1 = submission(user: bob, language: 'python')
    @s2 = submission(user: charlie, language: 'python', slug: 'word-count')

    # pending, in ruby
    @s3 = submission(user: bob)
    @s4 = submission(user: charlie, slug: 'word-count')
    @s5 = submission(user: dave)
    @s6 = submission(user: eve)
    @s7 = submission(user: fred)

    assert_equal 8, Submission.count # guard clause
  end

  def teardown
    Mongoid.reset
  end

  def test_mastery_gets_everything
    alice = User.create(username: 'alice', mastery: ['ruby', 'python'])
    workload = Workload.for(alice)

    pending = workload.pending
    assert_equal 7, pending.count
    refute pending.include?(s0)
  end

  def test_mastery_in_ruby_participant_in_python
    data = {
      username: 'alice',
      mastery: ['ruby'],
      completed: {'python' => ['bob']}
    }
    alice = User.create(data)
    workload = Workload.for(alice)
    pending = workload.pending
    assert_equal 6, pending.count
    refute pending.include?(s0)
    refute pending.include?(s2)
  end

  def test_non_master_gets_completed_exercises
    data = {
      username: 'alice',
      completed: {'ruby' => ['bob'], 'python' => ['bob']}
    }
    alice = User.create(data)
    workload = Workload.for(alice)
    pending = workload.pending
    assert_equal 5, pending.count
    refute pending.include?(s0)
    refute pending.include?(s2)
    refute pending.include?(s4)
  end

  def test_histogram_for_python
  end
end

class WorkloadTest < Minitest::Test
  def nitpick(submission, user)
    submission.nits << Nit.new(user: user, comment: 'stuff')
  end

  def submission(options = {})
    options = {language: 'ruby', slug: 'bob'}.merge(options)
    Submission.create(options)
  end

  def user(username, options = {})
    options = {
      username: username,
      current: {'ruby' => 'bob'}
    }.merge(options)
    User.create(options)
  end

  attr_reader :bob, :charlie, :dave, :eve, :fred, :george,
    :s0, :s1, :s2, :s3, :s4, :s5, :s6, :s7
  def setup
    @bob = user('bob')
    @charlie = user('charlie')
    @dave = user('dave')
    @eve = user('eve')
    @fred = user('fred')
    @george = user('george')

    assert_equal 0, Submission.count # guard clause
    @s1 = submission(user: bob)
    @s2 = submission(user: charlie) # nitpicks by user
    nitpick(s2, charlie)
    s2.save
    @s3 = submission(user: dave) # nitpicks by others
    nitpick(s3, bob)
    nitpick(s3, charlie)
    s3.save
    @s4 = submission(user: eve) # nitpicks by user + others
    nitpick(s4, bob)
    nitpick(s4, eve)
    nitpick(s4, charlie)
    @s5 = submission(user: fred, is_approvable: true)
    @s6 = submission(user: george, wants_opinions: true)
    assert_equal 6, Submission.count # guard clause
  end

  def teardown
    Mongoid.reset
  end

  def test_subsets
    alice = user('alice', mastery: ['ruby'])
    workload = Workload.for(alice)
    assert_equal 6, workload.pending.count # guard
    expected = [s1, s2, s5, s6].map {|s| s.user.username}.sort
    assert_equal expected, workload.nitless.map {|s| s.user.username}.sort

    assert_equal [s5.id], workload.liked.map(&:id)
    assert_equal [s6.id], workload.wants_opinions.map(&:id)
  end
end
