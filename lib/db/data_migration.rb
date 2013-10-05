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
    # ...
  end

  def self.migrate_users
    timeframes.each do |timeframe|
      User.unmigrated_in(timeframe).each do |user|
        PGUser.create(user.pg_attributes)
      end
    end
  end

  def self.timeframes
    @timeframes ||= MigrationPeriods.new
  end
end

