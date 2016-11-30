namespace :accounts do
  desc "merge two user accounts using environment variables SRC=<username-1> DST=<username-2>"
  task merge: [:connection] do
    if !ENV['SRC'] || !ENV['DST']
      STDERR.puts "Usage: SRC=<username-1> DST=<username-2> rake accounts:merge"
      exit 1
    end

    require 'exercism/user'

    src = User.find_by(username: ENV['SRC'])
    if !src
      STDERR.puts "Cannot find user record for %s" % ENV['SRC']
      exit 1
    end

    dst = User.find_by(username: ENV['DST'])
    if !dst
      STDERR.puts "Cannot find user record for %s" % ENV['DST']
      exit 1
    end

    require 'exercism/user_exercise'
    require 'exercism/named'
    require 'exercism/problem'
    require 'exercism/submission'
    require 'exercism/acl'

    src.exercises.each do |src_exercise|
      # sometimes people have done the same exercise on both accounts
      target = UserExercise.find_by(language: src_exercise.language, slug: src_exercise.slug, user_id: dst.id)
      if !!target
        # destination exists, we need to reset some stats on the old one
        # so it stops showing up on the old profile
        src_exercise.iteration_count = 0
        src_exercise.save
      else
        # destination doesn't exist, so move the old exercise to the new user account
        target = src_exercise
        target.user_id = dst.id
        target.save
      end

      src_exercise.submissions.each do |submission|
        # transfer old iterations to the new solution, without checking for duplicates
        submission.user_exercise_id = target.id
        submission.user_id = dst.id
        submission.save

        ACL.authorize(dst, submission.problem)
      end

      # reset all the iteration numbers
      target = UserExercise.find(target.id)
      target.submissions.order('created_at ASC').each_with_index do |submission, i|
        submission.version = i+1
        submission.save
      end
      target.iteration_count = target.submissions.count
      target.save
    end

    [
      # their user is going to end up with submissions that were created before they joined unless we update the
      # created at timestamp
      "UPDATE users SET created_at=(SELECT created_at FROM users WHERE id=%d) WHERE id=%d;" % [src.id, dst.id],
      # let's bring in all their comments, as well.
      "UPDATE comments SET user_id=%d WHERE user_id=%d;" % [dst.id, src.id],
      # Migrate the teams that they're managing.
      "UPDATE team_managers SET user_id=%d WHERE user_id=%d;" % [dst.id, src.id],
      # And their team memberships.
      "UPDATE team_memberships SET user_id=%d WHERE user_id=%d;" % [dst.id, src.id],
      # But not their invites and requests. They can go ask for that again.
      # We won't bring in views, watermarks etc, either.
    ].each do |stmt|
      ActiveRecord::Base.connection.execute(stmt)
    end
  end
end
