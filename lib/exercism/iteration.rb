class Iteration
  attr_reader :solution, :test_analysis, :code_analysis, :track, :slug

  def initialize(solution, options = {})
    @solution = {}
    solution.each do |filename, contents|
      @solution[filename] = contents.strip
    end
    # options = stuff.last || {}
    @test_analysis = options[:test_analysis]
    @code_analysis = options[:code_analysis]
    @track = options[:track]
    @slug = options[:slug]
  end

  # def paths
  #   @paths ||= solution.keys.map {|path, _| Code.new(path)}
  # end

  # def track
  #   paths.map(&:track).group_by {|k| k}.sort_by {|k, v| v.size}.last.first
  # end

  # def slug
  #   paths.map(&:slug).group_by {|k| k}.sort_by {|k, v| v.size}.last.first
  # end
end
