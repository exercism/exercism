class Iteration
  attr_reader :solution, :comment, :track_id, :slug

  def initialize(solution, track_id, slug, comment: nil)
    @track_id = track_id
    @slug = slug
    @comment = comment

    @solution = {}
    solution.each do |path, contents|
      filename = path.split(/\\|\//).join('/').gsub(/^\/?#{track_id}\/#{slug}\//i, "")
      @solution[filename] = contents.strip
    end
  end
end
