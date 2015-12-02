module X
  module Xapi
    require 'faraday'
    @@log = Faraday::Response::Logger
    
    VERSION = "v3"

    def self.url
      ENV.fetch('EXERCISES_API_URL') { "http://x.exercism.io" }
    end

    def self.conn
      Faraday.new(url: url) do |c|
        c.use @@log if @@log
        c.use Faraday::Adapter::NetHttp
      end
    end

    def self.request(*path_segments)
      options = {}
      if path_segments.last.is_a?(Hash)
        options = path_segments.pop
      end

      conn.get do |req|
        req.url File.join('/', VERSION, *path_segments)
        req.headers['User-Agent'] = "github.com/exercism/exercism.io"
        req.params = options
      end
    end

    def self.get(*path_segments)
      req = request(*path_segments)
      [req.status, req.body]
    end

    def self.no_logging
      @@log = nil
    end
  end
end
