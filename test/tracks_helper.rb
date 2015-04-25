module ExercismWeb
  module Presenters
    class Tracks
      def self.load_tracks
        tracks = JSON.parse(File.read("./test/fixtures/tracks.json"))["tracks"]
        @@tracks = tracks.map {|track| Track.new(track)}
      end
    end
  end
end

ExercismWeb::Presenters::Tracks.load_tracks
