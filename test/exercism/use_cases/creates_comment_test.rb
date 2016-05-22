require_relative '../../integration_helper'
require 'mocha/setup'

class CreatesCommentTest < Minitest::Test
  include DBCleaner

  def problem
    Problem.new('ruby', 'one')
  end

  def submission
    return @submission if @submission

    @submission = Submission.on(problem)
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
    assert_equal 'Too many variables', nit.body
    refute submission.liked?, "Should NOT be liked"
  end

  def test_should_return_invalid_comment_if_invalid
    nitpicker = User.new(username: 'alice')
    cc = CreatesComment.new(submission.id, nitpicker, '')
    cc.create
    assert cc.comment
  end

  def test_empty_nit_does_not_get_created
    nitpicker = User.new(username: 'alice')
    CreatesComment.new(submission.id, nitpicker, '').create
    assert_equal 0, submission.comments(true).count
  end

  def test_nitpicking_archived_exercise_does_not_reactivate_it
    nitpicker = User.new(username: 'alice')
    exercise = UserExercise.create(
      user: nitpicker,
      archived: true,
      submissions: [submission]
    )

    CreatesComment.new(submission.id, nitpicker, 'a comment').create
    exercise.reload
    assert exercise.archived?
  end

  def test_sanitation
    nitpicker = User.new(username: 'alice')
    content = "<script type=\"text/javascript\">bad();</script>good"
    ConvertsMarkdownToHTML.expects(:convert).with(content)
    CreatesComment.create(submission.id, nitpicker, content)
  end
end
