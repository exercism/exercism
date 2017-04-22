module ExercismWeb
  module Presenters
    class Track

      def initialize(track_id)
        @track_id = track_id
      end

      def method_missing(method, *args)
        if trackler_track.respond_to?(method)
          trackler_track.send(method, *args)
        else
          super
        end
      end

      def docs
        track_docs = trackler_track.docs(image_path: "/api/v1/tracks/%s/images/docs/img" % @track_id)

        track_docs.each_pair do |topic_key, topic_content|
          track_docs[topic_key] = if topic_content.present?
                                    [topic_content.strip, contributing_instructions(topic_key)].join("\n")
                                  else
                                    fallback_topic_content(topic_key)
                                  end
        end

        track_docs
      end

      private

      def fallback_topic_content(topic_key)
        filepath = "./x/docs/md/track/#{topic_key.upcase}.md"
        return '' unless File.exist?(filepath)
        File.read(filepath)
      end

      def trackler_track
        Trackler.tracks[@track_id]
      end

      def contributing_instructions(topic_key)
        File.
          read("./x/docs/md/track/BETTER.md").
          gsub('REPO', trackler_track.repository).
          gsub('TOPIC', topic_key.to_s.upcase).
          gsub('EXT', trackler_track.doc_format)
      end

    end
  end
end
