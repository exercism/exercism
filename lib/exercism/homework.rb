class Homework
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def all
    sql = <<-SQL
    SELECT language, slug, archived
    FROM user_exercises
    WHERE user_id=#{user.id}
    AND (iteration_count>0 OR skipped_at IS NOT NULL)
    ORDER BY language, slug ASC
    SQL
    extract(sql)
  end

  private

  def extract(sql)
    UserExercise.connection.execute(sql).each_with_object(empty_hash) do |row, exercises|
      exercises[row['language']] << { 'slug' => row['slug'], 'state' => row['archived'] == 't' ? 'archived' : 'active' }
    end
  end

  def empty_hash
    Hash.new { |hash, key| hash[key] = [] }
  end
end
