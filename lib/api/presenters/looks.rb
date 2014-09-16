require_relative '../../exercism/named'

module ExercismAPI
  module Presenters
    class Looks
      include Named

      def self.for(user)
        sql = <<-SQL
        SELECT
          ux.language AS track_id,
          ux.slug,
          u.username,
          ux.key
        FROM user_exercises ux
        INNER JOIN looks lk ON lk.exercise_id=ux.id
        INNER JOIN users u ON u.id=ux.user_id
        WHERE lk.user_id=#{user.id}
        ORDER BY lk.created_at DESC
        SQL
        ActiveRecord::Base.connection.execute(sql).to_a.map {|row|
          new(row)
        }
      end

      attr_reader :track_id, :slug, :username, :key
      def initialize(attributes)
        @track_id = attributes['track_id']
        @slug = attributes['slug']
        @username = attributes['username']
        @key = attributes['key']
      end

      def path
        "/%s/%s" % [username, key]
      end

      def language
        Language.of(track_id)
      end
    end
  end
end
