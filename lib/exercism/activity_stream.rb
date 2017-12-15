require 'will_paginate/array'

module ActivityStream
  def exercises
    @exercises ||= query_exercises
  end

  def pagination
    (1..pagination_menu_item.total).to_a.paginate(page: page, per_page: per_page)
  end

  # This becomes unbearably slow if we do a left join on views to get the unread value
  # up front.
  # If performance is still a problem, remove the join on user and do a separate lookup
  # for that as well.
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def query_exercises
    exx = []
    ids = []
    by_problem_id = Hash.new { |h, k| h[k] = [] }
    exx_by_id = execute(exercises_sql).each_with_object({}) do |row, by_id|
      problem = Problem.new(row["language"], row["slug"])
      attrs = [
        row["id"].to_i,
        row["uuid"],
        problem,
        row["last_activity"],
        row["last_activity_at"],
        row["iteration_count"].to_i,
        row["help_requested"] == 't',
        row["username"],
        row["avatar_url"],
      ]
      ex = Stream::Exercise.new(*attrs)
      exx << ex

      ids << row["id"]
      by_problem_id[ex.problem.id] << ex
      by_id[row["id"]] = ex
    end

    watermarks(by_problem_id.keys).each do |watermark|
      by_problem_id[watermark.problem_id].each do |ex|
        if DateTime.parse(ex.last_activity_at) <= watermark.at
          ex.viewed!
        end
      end
    end

    viewed(ids).each do |id|
      exx_by_id[id].viewed!
    end

    comment_counts(ids).each do |id, count|
      exx_by_id[id].comment_count = count.to_i
    end

    exx
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def comment_counts(ids)
    return [] if ids.empty?

    execute(comment_counts_sql(ids)).map { |row| [row["id"], row["total"]] }
  end

  def viewed(ids)
    return [] if ids.empty?

    execute(viewed_sql(ids)).map { |row| row["id"] }
  end

  def comment_counts_sql(ids)
    <<-SQL
    SELECT s.user_exercise_id AS id, COUNT(c.id) AS total
    FROM submissions s
    INNER JOIN comments c
    ON c.submission_id=s.id
    WHERE s.user_exercise_id IN (#{ids.join(',')})
    GROUP BY s.user_exercise_id
    SQL
  end

  def slug_param
    if slug.nil?
      'ex.slug'
    else
      "'#{slug}'"
    end
  end

  def offset
    (page - 1) * per_page
  end
end
