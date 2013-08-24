Exercise = Struct.new(:language, :slug) do
  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end

  def to_s
    "Exercise: #{slug} (#{namify(language)})"
  end

  def in?(other_language)
    language == other_language
  end

  private

  def namify(s)
    s.split('-').map(&:capitalize).join(' ')
  end
end
