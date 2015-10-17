class Successor
  def self.from(session, params, problem)
    track_id, slug = problem.track_id, problem.slug
    if params[:i] == '1'
      track_id, slug = session[:inbox], session[:inbox_slug]
    end
    new(track_id, slug)
  end

  attr_reader :track_id, :slug
  def initialize(track_id, slug)
    @track_id, @slug = track_id, slug
  end

  def to_params
    q = {language: track_id}
    q = q.merge(slug: slug) if !!slug
    '?' + q.map {|pair| pair.join("=") }.join("&")
  end
end
