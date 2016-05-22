class Code
  attr_reader :path
  def initialize(path)
    @path = path
  end

  def filename
    @filename ||= path_segments.last
  end

  def extension
    @extension ||= filename[/([^\.]+)\Z/, 1]
  end

  def slug
    path_segments[1].downcase if path_segments[1]
  end

  def track
    path_segments[0].downcase if path_segments[0]
  end

  private

  def path_segments
    @path_segments ||= path.split(/\/|\\/).reject(&:empty?)
  end
end
