Exercise = Struct.new(:language, :slug) do

  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end

  def to_s
    "#<Exercise #{language}:#{slug}"
  end

end
