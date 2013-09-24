require './test/integration_helper'

class CreatesCommentTest < Minitest::Test

  def exercise
    Exercise.new('nong', 'one')
  end

  def submission
    return @submission if @submission

    @submission = Submission.on(exercise)
    @submission.user = User.create(username: 'bob')
    @submission.save
    @submission
  end

  def teardown
    super
    @bob = nil
    @submission = nil
  end

  def test_nitpicking_a_submission_saves_a_nit
    nitpicker = User.new(username: 'alice')
    CreatesComment.new(submission.id, nitpicker, 'Too many variables').create
    nit = submission.reload.comments.first
    assert submission.pending?, "Should be pending"
    assert_equal 'Too many variables', nit.body
    refute submission.liked?, "Should NOT be liked"
  end

  def test_nitpicking_a_submission_mutes_it
    nitpicker = User.new(username: 'alice')
    CreatesComment.new(submission.id, nitpicker, 'Too many variables').create
    assert submission.reload.muted_by?(nitpicker), 'should be muted'
  end

  def test_empty_nit_does_not_get_created
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, '').create
    assert_equal 0, submission.reload.comments.count
  end

  def test_empty_nit_does_not_mute
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, '').create
    refute submission.reload.muted_by?(nitpicker)
  end

  def test_nitpicking_hibernating_exercise_sets_it_to_pending
    submission.state = 'hibernating'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, 'a comment').create
    submission.reload
    assert submission.pending?
  end

  def test_do_not_change_state_of_completed_submission
    submission.state = 'done'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, 'a comment').create
    submission.reload
    assert submission.done?
  end

  def test_do_not_change_state_of_superseded_submission
    submission.state = 'superseded'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, 'a comment').create
    submission.reload
    assert submission.superseded?
  end

  def test_nitpick_with_mentions
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, "Mention @#{@submission.user.username}").create
    submission.reload
    comment = submission.comments.last
    assert_equal 1, comment.mentions.count
    assert_equal submission.user, comment.mentions.first
  end

  def test_ignore_mentions_in_code_spans
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, "`@#{@submission.user.username}`").create
    submission.reload
    comment = submission.comments.last
    assert_equal 0, comment.mentions.count
  end

  def test_ignore_mentions_in_fenced_code_blocks
    nitpicker = User.new(username: 'alice')
    nitpick = CreatesComment.new(submission.id, nitpicker, "```\n@#{submission.user.username}\n```").create
    submission.reload
    comment = submission.comments.last
    assert_equal 0, comment.mentions.count
  end

  def test_sanitation
    nitpicker = User.new(username: 'alice')
    content = "<script type=\"text/javascript\">bad();</script>good"
    ConvertsMarkdownToHTML.expects(:convert).with(content)
    CreatesComment.create(submission.id, nitpicker, content)
  end

end
