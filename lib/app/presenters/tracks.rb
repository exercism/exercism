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
        @active ||= tracks.select(&:active?)
      end

      def upcoming
        @upcoming ||= tracks.select(&:upcoming?)
      end

      def planned
        @planned ||= tracks.select(&:planned?)
      end
    end
  end
end
