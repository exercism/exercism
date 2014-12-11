module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        redirect "/stats/#{Exercism::Config.languages.keys.first}"
      end

      get '/stats/:track_id' do |track_id|
        please_login

        track_ids = Exercism::Config.languages.keys
        progress = ExercismWeb::Presenters::Progress.new(track_id)
        erb :"stats/show", locals: {track_ids: track_ids, progress: progress}
      end
    end
  end
end
