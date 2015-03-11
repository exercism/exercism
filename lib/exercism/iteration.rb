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
    @track_id || paths.map(&:track).group_by {|k| k}.sort_by {|k, v| v.size}.last.first
  end

  def slug
    @slug || paths.map(&:slug).group_by {|k| k}.sort_by {|k, v| v.size}.last.first
  end
end
