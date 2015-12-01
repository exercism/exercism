require_relative '../x'

module X
  module Xapi
    def self.get(*path_segments)
      [200, File.read('./test/fixtures/xapi_v3_tracks.json')]
    end
  end
end
