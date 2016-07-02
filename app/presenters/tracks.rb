require 'json'

module ExercismWeb
  module Presenters
    class Track < OpenStruct
      def active?
        active
      end

      def upcoming?
        !active? && problems.length > 2
      end

      def planned?
        !active? && problems.length <= 2
      end
    end

    class Tracks
      def self.tracks
        @@tracks ||= fetch_tracks
      end

      def self.find(id)
        tracks.find { |track| track.id == id }
      end

      def self.active
        @@active ||= tracks.select(&:active?)
      end

      def self.upcoming
        @@upcoming ||= tracks.select(&:upcoming?)
      end

      def self.planned
        @@planned ||= tracks.select(&:planned?)
      end

      def self.fetch_tracks
        status, body = Xapi.get("tracks")
        fail "something fishy in x-api: (#{status}) - #{body}" if status != 200
        tracks = JSON.parse(body)["tracks"]
        tracks.map { |track| Track.new(track) }
      end
    end
  end
end
