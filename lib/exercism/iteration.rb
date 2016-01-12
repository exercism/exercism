class Iteration
  attr_reader :solution, :paths, :comment

  def initialize(solution, track_id=nil, slug=nil, comment: nil)
    @track_id = track_id
    @slug = slug
    @comment = comment
    @paths = solution.keys.map { |path| Code.new(path) }

    @solution = {}
    solution.each do |path, contents|
      @solution[filename(path)] = contents.strip
    end
  end

  def track_id
    @track_id || max_occurrences(paths.map(&:track))
  end

  def slug
    @slug || max_occurrences(paths.map(&:slug))
  end

  private

  def max_occurrences(ary)
    ary.group_by(&:itself).values.max_by(&:size).first
  end

  def filename(path)
    Code.new(path).filename
  end
end
