# Models
require './lib/db/data_migration/comment'
require './lib/db/data_migration/notification'
require './lib/db/data_migration/submission'
require './lib/db/data_migration/team'
require './lib/db/data_migration/user'

# Helper classes
require './lib/db/data_migration/migration_periods'
require './lib/db/data_migration/timeframe'

class DataMigration
  def self.execute
    migrate_users
    migrate_submissions
    migrate_teams
    migrate_comments
    migrate_notifications
  end

  def self.migrate_users
    timeframes.each do |timeframe|
      User.unmigrated_in(timeframe).each do |user|
        PGUser.create(user.pg_attributes)
      end
    end
    puts "MongoDB.Users: #{User.count}, PostgreSQL.Users: #{PGUser.count}"
  end

  def self.migrate_submissions
    timeframes.each do |timeframe|
      Submission.unmigrated_in(timeframe).each do |submission|
        pg_submission = PGSubmission.create(submission.pg_attributes)
        migrate_submission_viewers(submission, pg_submission)
        migrate_muted_submissions(submission, pg_submission)
        migrate_likes(submission, pg_submission)
      end
    end
    puts "MongoDB.Submissions: #{Submission.count}, PostgreSQL.Submission: #{PGSubmission.count}"
  end

  def self.migrate_submission_viewers(submission, pg_submission)
    submission.viewers.each do |username|
      viewer = PGUser.find_by_username(username)
      SubmissionViewer.create(viewer_id: viewer.id, submission_id: pg_submission.id)
    end
  end

  def self.migrate_muted_submissions(submission, pg_submission)
    submission.muted_by.each do |username|
      user = PGUser.find_by_username(username)
      MutedSubmission.create(user_id: user.id, submission_id: pg_submission.id)
    end
  end

  def self.migrate_likes(submission, pg_submission)
    submission.liked_by.each do |username|
      user = PGUser.find_by_username(username)
      Like.create(user_id: user.id, submission_id: pg_submission.id)
    end
  end

  def self.migrate_teams
    Team.unmigrated.each do |team|
      pg_team = PGTeam.create(team.pg_attributes)
      migrate_team_memberships(team, pg_team)
    end
    puts "MongoDB.Teams: #{Team.count}, PostgreSQL.Teams: #{PGTeam.count}"
  end

  def self.migrate_team_memberships(team, pg_team)
    team.members.each do |member|
      TeamMembership.create(user_id: member.pg_user.id, team_id: pg_team.id)
    end
  end

  def self.migrate_comments
    timeframes.each do |timeframe|
      Comment.unmigrated_in(timeframe).each do |comment|
        PGComment.create(comment.pg_attributes)
      end
    end
    puts "MongoDB.Comments: #{Comment.count}, PostgreSQL.Comments: #{PGComment.count}"
  end

  def self.migrate_notifications
    # First, let's delete read notifications if they're old
    Notification.where(:at.lt => (Date.today - 2), :read => true).delete_all

    timeframes.each do |timeframe|
      Notification.unmigrated_in(timeframe).each do |notification|
        PGNotification.create(notification.pg_attributes)
      end
    end
    puts "MongoDB.Notifications: #{Notification.count}, PostgreSQL.Notifications: #{PGNotification.count}"
  end

  def self.timeframes
    @timeframes ||= MigrationPeriods.new
  end
end

