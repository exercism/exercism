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
        erb :"languages/language", locals: {
          track: track,
          docs: X::Docs::Launch.new(track.repository),
        }
      end
    end
  end
end
