module Xapi
  def self.exercises_api_url
    ENV.fetch('EXERCISES_API_URL') { "http://x.exercism.io" }
  end

  def self.exists?(language, slug)
    request('exercises', language, slug).status != 404
  end

  def self.conn
    Faraday.new(:url => exercises_api_url) do |c|
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
  end

  def self.request(*path_segments)
    options = {}
    if path_segments.last.is_a?(Hash)
      options = path_segments.pop
    end

    conn.get do |req|
      req.url File.join('/', *path_segments)
      req.headers['User-Agent'] = "github.com/exercism/exercism.io"
      req.params = options
    end
  end

  def self.get(*path_segments)
    request(*path_segments).body
  end
end
