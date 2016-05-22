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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def status(language)
    exercises = user.exercises.where(language: language)

    skipped = exercises.where.not(skipped_at: nil).pluck(:slug)
    submitted = exercises.where('skipped_at IS NULL AND iteration_count > ?', 0).pluck(:slug)
    recent = exercises.where.not(last_iteration_at: nil)
                      .order(:last_iteration_at).last

    if recent.nil?
      msg = "You haven't submitted any solutions yet."
      recent = Struct.new(:slug, :last_iteration_at).new(msg, Time.now)
    end

    {
      track_id: language,
      recent: {
        problem: recent.slug,
        submitted_at: recent.last_iteration_at,
      },
      skipped: skipped,
      submitted: submitted,
      fetched: ["sorry, tracking disabled for fetching"],
    }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
