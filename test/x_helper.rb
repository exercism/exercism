require_relative '../x'
require 'json'

module X
  class Track
    def self.all
      tracks = JSON.parse(File.read("./test/fixtures/xapi_v3_tracks.json"))['tracks']
      tracks.map { |track| Track.new(track) }
    end
  end
end
