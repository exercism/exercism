require 'json'
require './lib/app/presenters/tracks.rb'
module ExercismWeb
  module Presenters
    class Tracks
      def self.load_tracks
        tracks = JSON.parse(File.read("./test/fixtures/tracks.json"))["tracks"]
        @@tracks = tracks {|track| Track.new(track)}
      end
    end
  end
end

ExercismWeb::Presenters::Tracks.load_tracks
