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
      def self.xapi
        status, body = Xapi.get("tracks")
        if status != 200
          raise "something fishy in x-api: (#{status}) - #{body}"
        end
        new(JSON.parse(body)["tracks"])
      end

      attr_reader :tracks
      def initialize(tracks)
        @tracks = tracks.map {|track| Track.new(track)}
      end

      def active
        tracks.select(&:active?).map(&:language)
      end

      def upcoming
        tracks.select(&:upcoming?).map(&:language)
      end

      def planned
        tracks.select(&:planned?).map(&:language)
      end
    end
  end
end
