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

      get '/languages/:track_id/contribute?' do |track_id|
        page = params[:page] || 1
        stream = TodoStream.new(track_id, page)
        if stream
          erb :"languages/contribute", locals: { stream: stream.pagination, track_id: track_id }
        else
        end
      end
    end
  end
end
