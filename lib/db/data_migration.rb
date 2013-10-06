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
    # ...
  end

  def self.migrate_users
    timeframes.each do |timeframe|
      User.unmigrated_in(timeframe).each do |user|
        PGUser.create(user.pg_attributes)
      end
    end
  end

  def self.migrate_submissions
    timeframes.each do |timeframe|
      Submission.unmigrated_in(timeframe).each do |submission|
        PGSubmission.create(submission.pg_attributes)
      end
    end
  end

  def self.migrate_teams
    Team.unmigrated.each do |team|
      pg_team = PGTeam.create(team.pg_attributes)
      team.members.each do |member|
        TeamMembership.create(user_id: member.pg_user.id, team_id: pg_team.id)
      end
    end
  end

  def self.migrate_comments
    timeframes.each do |timeframe|
      Comment.unmigrated_in(timeframe).each do |comment|
        PGComment.create(comment.pg_attributes)
      end
    end
  end

  def self.timeframes
    @timeframes ||= MigrationPeriods.new
  end
end

