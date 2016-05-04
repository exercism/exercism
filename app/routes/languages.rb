require_relative '../../x'

module ExercismWeb
  module Routes
    class Languages < Core
      get '/languages' do
        tracks = X::Track.all
        active, inactive = tracks.partition { |t| t.active? }
        inactive.sort! { |a, b| b.problems.count <=> a.problems.count }
        erb :"languages/index", locals: { active: active, inactive: inactive }
      end

      get '/languages/:track_id' do |track_id|
        track = X::Track.find(track_id)
        if track.implemented?
          erb :"languages/language", locals: { track: track }
        else
          erb :"languages/not_implemented", locals: { track: track }
        end
      end

      get '/languages/:track_id/contribute' do |track_id|
        track = X::Todo.track(track_id)
        if track.any?
          erb :"languages/contribute", locals: { todos: track.with_implementations, language: track.language, track_id: track_id }
        end
      end
    end
  end
end
