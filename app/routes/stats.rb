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
          slugs = track.problems.map(&:slug)
          stats = ExercismLib::Stats.new(track_id, slugs)
          datasets = [
            stats,
            ExercismLib::Stats.new(track_id, slugs, ExercismLib::Stats::LastN.new(90)),
            ExercismLib::Stats.new(track_id, slugs, ExercismLib::Stats::LastN.new(120))
          ] + stats.historical(6)

          erb :"stats/index", locals: {tracks: tracks.select(&:active?).sort_by(&:language), track: track, datasets: datasets}
        else
          status 404
          erb :"errors/not_found"
        end
      end
    end
  end
end
