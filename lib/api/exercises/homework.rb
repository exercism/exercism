class Homework
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def current
    sql = "SELECT language, slug FROM user_exercises WHERE user_id = #{user.id} AND state IN ('pending', 'hibernating') ORDER BY language, slug ASC"
    extract(sql)
  end

  def all
    sql = "SELECT language, slug FROM user_exercises WHERE user_id = #{user.id} ORDER BY language, slug ASC"
    extract(sql)
  end

  private

  def extract(sql)
    exercises = Hash.new {|exercises, key| exercises[key] = []}
    UserExercise.connection.execute(sql).each_with_object(exercises) {|row, exercises|
      exercises[row['language']] << row["slug"]
    }
  end
end
