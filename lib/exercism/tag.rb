class Tag < ActiveRecord::Base
  TRIGRAM_SIZE = 3
  SIMILARITY = 0.8

  def self.create_from_text(tags)
    tags.to_s.downcase.split(",").reject(&:blank?).uniq.map do |tag|
      tag = Tag.where(name: tag.strip).first_or_create!
      tag.id
    end
  end

  def self.find_by_similarity(query)
    return [] if query.blank?

    query = ActiveRecord::Base.connection.quote(query)

    ActiveRecord::Base.connection.select_values(
      find_by_similarity_sql(query)
    )
  end

  def self.find_by_similarity_sql(query)
    <<-SQL
    SELECT name
    FROM (
      SELECT name, name <-> #{query} AS dist
      FROM tags
      ORDER BY dist
      LIMIT 10
    ) AS tags_distance
    WHERE dist < #{SIMILARITY};
    SQL
  end
end
