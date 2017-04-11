module ExercismWeb
  module Presenters
    class Track

      def initialize(track_id)
        @track_id = track_id
      end

      def method_missing(method, *args)
        trackler_track.send(method, *args)
      end

      def docs
        track_docs = trackler_track.docs("/api/v1/tracks/%s/images/docs/img" % @track_id)

        track_docs.each_pair do |topic_name, topic_content|
          track_docs[topic_name] = if topic_content.present?
                                     topic_content
                                   elsif default_topic_content(topic_name).present?
                                     default_topic_content(topic_name)
                                   else
                                     ''
                                   end
        end

        track_docs
      end

      private

      def default_topic_content(topic_name)
        filepath = "./x/docs/md/track/#{topic_name.upcase}.md"
        File.read(filepath) if File.exist?(filepath)
      end

      def trackler_track
        Trackler.tracks[@track_id]
      end

    end
  end
end
