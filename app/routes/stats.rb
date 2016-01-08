module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        redirect "/stats/#{tracks.select(&:active?).first.slug}"
      end

      get '/stats/:track_id' do |track_id|
        track_id = track_id.downcase
        tracks = X::Track.all.reject {|track| track.problems.empty? }
        track = tracks.find {|t| t.id == track_id }

        if !!track
          stats = ExercismLib::Stats.new(track_id, track.problems.map(&:slug))
          erb :"stats/index", locals: {tracks: tracks.select(&:active?), track: track, stats: stats}
        else
          status 404
          erb :"errors/not_found"
        end
      end
    end
  end
end
