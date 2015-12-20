require_relative '../../x'

module ExercismWeb
  module Routes
    class Languages < Core
      get '/languages' do
        erb :"languages/index"
      end

      get '/languages/:track_id' do |track_id|
        track = X::Track.find(track_id)
        if track.implemented?
          erb :"languages/language", locals: { track: track }
        else
          erb :"languages/not_implemented", locals: { track: track }
        end
      end
    end
  end
end
