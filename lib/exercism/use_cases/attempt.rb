require 'exercism/xapi'

class Attempt

  attr_reader :user, :code, :track, :slug, :filename, :iteration
  def initialize(user, *stuff)
    @user = user
    if stuff.last.is_a?(Iteration)
      @iteration = stuff.last
    else
      # TODO:
      # 1. Change tests to use new iteration style
      # 2. get rid of *stuff
      # 3. get rid of code, filename attrs (don't write it on submission)
      code, path = stuff
      @iteration = Iteration.new({path => code})
    end
    @slug = iteration.slug
    @track = iteration.track

    # hack
    @code = iteration.solution.values.first
    @filename = iteration.solution.keys.first
  end

  def valid?
    !!slug && Xapi.exists?(track, slug)
  end

  def submission
    @submission ||= Submission.on(problem)
  end

  def problem
    Problem.new(track, slug)
  end

  def save
    user.submissions_on(problem).each do |sub|
      sub.supersede!
      sub.unmute_all!
    end
    remove_from_completed(problem)
    submission.solution = iteration.solution
    submission.code = code
    submission.analysis = iteration.code_analysis
    submission.test_output = iteration.test_analysis
    submission.filename = filename
    user.submissions << submission
    user.save
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    self
  end

  def remove_from_completed(problem)
    (user.completed[problem.track_id] || []).delete(problem.slug)
  end

  def duplicate?
    !code.empty? && previous_submission.code == code
  end

  def previous_submissions
    @previous_submissions ||= user.submissions_on(problem).reject {|s| s == submission}
  end

  def previous_submission
    @previous_submission ||= previous_submissions.first || NullSubmission.new(problem)
  end

  class InvalidAttemptError < StandardError; end
end

