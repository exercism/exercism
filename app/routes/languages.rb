require_relative '../../x'

module ExercismWeb
  module Routes
    class Languages < Core
      get '/languages' do
        tracks = X::Track.all
        active, inactive = tracks.partition(&:active?)
        inactive.sort! { |a, b| b.problems.count <=> a.problems.count }
        erb :"languages/index", locals: { active: active, inactive: inactive }
      end

      get '/languages/:track_id' do |track_id|
        _, body = X::Xapi.get('tracks', track_id)
        parsed_body = JSON.parse(body)
        if parsed_body['error'] == "No track '#{track_id}'"
          erb :"languages/not_found", locals: { track_id: track_id }
        else
          track = X::Track.new(parsed_body['track'])
          erb :"languages/language", locals: {
            track: track,
            docs: X::Docs::Launch.new(track.repository),
          }
        end
      end

      get '/languages/:track_id/contribute' do |track_id|
        track = X::Todo.track(track_id)
        if track.any?
          erb :"languages/contribute", locals: { todos: track.with_implementations,
                                                 language: track.language,
                                                 repository: track.repository,
                                                 track_id: track_id }
        end
      end
    end
  end
end
