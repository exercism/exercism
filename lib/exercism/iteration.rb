class Iteration
  attr_reader :solution

  def initialize(solution, track_id=nil, slug=nil)
    @track_id = track_id
    @slug = slug
    @solution = {}
    solution.each do |filename, contents|
      @solution[filename] = contents.strip
    end
  end

  def paths
    @paths ||= solution.keys.map {|path, _| Code.new(path)}
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
end
