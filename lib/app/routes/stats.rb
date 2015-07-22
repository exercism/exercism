module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        redirect "/stats/#{active_tracks.first.slug}"
      end

      get '/stats/:track_id' do |track_id|
        track = tracks.find {|t| t.id == track_id}
        if track.nil?
          status 404
          erb :"errors/not_found"
        else
          progress = ExercismWeb::Presenters::Progress.new(track.slug, track.language)
          erb :"stats/show", locals: {tracks: active_tracks, progress: progress}
        end
      end

      private

      def active_tracks
        @active_tracks ||= tracks.select(&:active?)
      end
    end
  end
end
