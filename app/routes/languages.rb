require_relative '../../x'

module ExercismWeb
  module Routes
    class Languages < Core
      TOPICS = %w(about exercises installing tests learning resources help launch contribute todo).freeze

      get '/languages' do
        tracks = Trackler.tracks
        erb :"languages/index", locals: {
          active: tracks.select(&:active?),
          upcoming: tracks.select(&:upcoming?),
          planned: tracks.select(&:planned?)
        }
      end

      get '/repositories' do
        tracks = Trackler.tracks
        erb :"languages/repositories", locals: {
          active: tracks.select(&:active?),
          upcoming: tracks.select(&:upcoming?),
          planned: tracks.select(&:planned?)
        }
      end

      get '/languages/:track_id' do |track_id|
        track = Trackler.tracks[track_id]
        if track.exists?
          topic = track.active? ? "about" : "launch"
          redirect "/languages/#{track_id}/#{topic}"
        else
          status 404
          erb :"languages/not_found", locals: { track_id: track_id }
        end
      end

      get '/languages/:track_id/:topic' do |track_id, topic|
        template = topic
        unless TOPICS.include?(topic)
          status 404
          template = "topic_not_found"
        end

        track = Trackler.tracks[track_id]
        if track.exists?
          erb :"languages/language", locals: {
            track: track,
            topic: topic,
            template: template,
            docs: track.docs("/api/v1/tracks/%s/images/docs/img" % track_id)
          }
        else
          language_not_found(track_id)
        end
      end

      def language_not_found(track_id)
        status 404
        erb :"languages/not_found", locals: { track_id: track_id }
      end
    end
  end
end
