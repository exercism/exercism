Exercise = Struct.new(:language, :slug) do
  include Named

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
