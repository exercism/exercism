require 'json'

module ExercismWeb
  module Presenters
    class Doc < OpenStruct
    end

    class Docs
      def initialize(track_id)
        @track_id = track_id
      end

      def track_docs
        @track_docs ||= fetch_docs
      end

      def fetch_docs
        status, body = Xapi.get("docs/#{@track_id}")
        if status != 200
          raise "something fishy in x-api: (#{status}) - #{body}"
        end
        body = JSON.parse(body)
      end

      def about
        track_docs["docs"]["about"]
      end
    end
  end
end
