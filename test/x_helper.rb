require_relative '../x'

module X
  module Xapi
    def self.get(*path_segments)
      if path_segments.first.eql?("tracks")
        if path_segments.count == 1
          [200, File.read('./test/fixtures/xapi_v3_tracks.json')]
        else
          [200, File.read("./test/fixtures/xapi_v3_tracks_#{path_segments.last}.json")]
        end
      end
    end
  end
end

X::Language.tracks = {}
