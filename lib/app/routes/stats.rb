module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        redirect "/stats/#{tracks.active.first.track_id}"
      end

      get '/stats/:track_id' do |track_id|
        track = tracks.find(track_id)
        if track.nil?
          status 404
          erb :"errors/not_found"
        else
          progress = ExercismWeb::Presenters::Progress.new(track.id, track.language)
          erb :"stats/show", locals: {tracks: tracks.active, progress: progress}
        end
      end
    end
  end
end
