module Trending
  Exercise = Struct.new(:uuid, :track_id, :slug, :username) do
    include Named

    def language
      Language.of(track_id)
    end
  end

  # TODO: select exercises, not submissions
  def self.for(user, timeframe)
    ts = Time.now-timeframe
    sql = <<-SQL
      SELECT
        s.key AS uuid,
        s.language,
        s.slug,
        u.username

        FROM submissions s

        INNER JOIN users u ON u.id=s.user_id

        LEFT JOIN (
          SELECT COUNT(c.id) AS total_comments, sub.id
          FROM submissions sub
          INNER JOIN comments c
          ON c.submission_id=sub.id
          WHERE c.created_at > '#{ts}'
          GROUP BY sub.id
        ) AS t1
        ON t1.id=s.id

        LEFT JOIN (
          SELECT COUNT(lk.id) AS total_likes, sub.id
          FROM submissions sub
          INNER JOIN likes lk
          ON lk.submission_id=sub.id
          WHERE lk.created_at > '#{ts}'
          GROUP BY sub.id
        ) AS t2
        ON t2.id=s.id

        INNER JOIN acls
        ON acls.language=s.language AND acls.slug=s.slug

        WHERE (
          COALESCE(total_likes,0) + COALESCE(total_comments,0) > 0
        )
        AND acls.user_id=#{user.id}

        ORDER BY COALESCE(total_likes,0) + COALESCE(total_comments,0) DESC
        LIMIT 10
      SQL

      ActiveRecord::Base.connection.execute(sql).to_a.map {|row|
        Exercise.new(row['uuid'], row['language'], row['slug'], row['username'])
      }
  end
end
