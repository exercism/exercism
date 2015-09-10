class Work
  attr_reader :user

  class Suggestion < Struct.new(:uuid, :language, :slug, :username)
  end

  def initialize(user)
    @user = user
  end

  def random
    row = rows.sample
    return if row.nil?

    Suggestion.new(row["uuid"], row["language"], row["slug"], row["username"])
  end

  private

  def rows
    ActiveRecord::Base.connection.execute(exercises_sql).to_a
  end

  # exercises that the user has access to, which were submitted in the past
  # month, and which have no comments yet.
  def exercises_sql
    <<-SQL
      SELECT
        ex.id, ex.key AS uuid, ex.language, ex.slug, u.username
      FROM user_exercises ex
      INNER JOIN acls
        ON ex.language=acls.language AND ex.slug=acls.slug
      INNER JOIN submissions s
        ON ex.id=s.user_exercise_id
        AND ex.iteration_count=s.version
      INNER JOIN users u
        ON u.id=ex.user_id
      WHERE ex.iteration_count > 0
        AND acls.user_id=6
        AND ex.last_activity_at > (NOW()-interval '30 days')
        AND s.id NOT IN (SELECT DISTINCT c.submission_id FROM comments c)
      LIMIT 100;
    SQL
  end

end
