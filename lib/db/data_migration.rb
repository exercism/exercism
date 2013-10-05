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
    # ...
  end
end

