require_relative '../../x'

module ExercismWeb
  module Routes
    class Languages < Core
      get '/languages' do
        tracks = X::Track.all
        active, inactive = tracks.partition { |t| t.active? }
        inactive.sort! { |a, b| b.problems.count <=> a.problems.count }
        submissions_count = current_user.submissions_per_language
        erb :"languages/index", locals: { active: active, inactive: inactive,
                                          submissions_count: submissions_count }
      end

      get '/languages/:track_id' do |track_id|
        track = X::Track.find(track_id)
        if track.implemented?
          erb :"languages/language", locals: {
            track: track,
            docs: X::Docs::Launch.new(track.repository),
          }
        else
          erb :"languages/not_implemented", locals: { track: track }
        end
      end
    end
  end
end
