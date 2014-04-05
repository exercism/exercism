class Homework
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def all
    sql = "SELECT language, slug, state FROM user_exercises WHERE user_id = #{user.id} ORDER BY language, slug ASC"
    extract(sql)
  end

  private

  def extract(sql)
    exercises = Hash.new {|exercises, key| exercises[key] = []}
    UserExercise.connection.execute(sql).each_with_object(exercises) {|row, exercises|
      exercises[row['language']] << {"slug" => row["slug"], "state" => row["state"]}
    }
  end
end
