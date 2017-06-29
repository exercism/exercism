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
        trackler_topics.each_with_object(OpenStruct.new) do |topic_key, result|
          result[topic_key] = topic_content(topic_key)
        end
      end

      private

      def trackler_track
        Trackler.tracks[@track_id]
      end

      def trackler_docs
        trackler_track.docs(image_path: "/api/v1/tracks/%s/images/docs/img" % @track_id)
      end

      def trackler_topics
        trackler_docs.to_h.keys
      end

      def trackler_topic_content(topic_key)
        trackler_docs[topic_key]
      end

      def topic_content(topic_key)
        if trackler_topic_content(topic_key).present?
          [trackler_topic_content(topic_key).strip, contributing_instructions(topic_key)].join("\n")
        else
          fallback_topic_content(topic_key)
        end
      end

      def contributing_instructions(topic_key)
        template = File.read(shared_template_filepath("BETTER"))
        populate_template_with_trackler_data(template).gsub('TOPIC', topic_key.to_s.upcase)
      end

      def fallback_topic_content(topic_key)
        template_filepath = shared_template_filepath(topic_key.upcase)
        return '' unless File.exist?(template_filepath)
        template = File.read(template_filepath)
        populate_template_with_trackler_data(template)
      end

      def populate_template_with_trackler_data(template)
        template.gsub('REPO', trackler_track.repository).gsub('EXT', trackler_track.doc_format)
      end

      def shared_template_filepath(template_name)
        "./x/docs/md/track/#{template_name}.md"
      end

    end
  end
end
