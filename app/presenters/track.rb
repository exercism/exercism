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
        track_docs = trackler_track.docs("/api/v1/tracks/%s/images/docs/img" % @track_id)

        track_docs.each_pair do |topic_name, topic_content|
          track_docs[topic_name] = if topic_content.present?
                                     topic_content
                                   else
                                     default_topic_content(topic_name)
                                   end
        end

        track_docs
      end

      private

      def default_topic_content(topic_name)
        filepath = "./x/docs/md/track/#{topic_name.upcase}.md"
        return '' unless File.exist?(filepath)
        File.read(filepath)
      end

      def trackler_track
        Trackler.tracks[@track_id]
      end

    end
  end
end
