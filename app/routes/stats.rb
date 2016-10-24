module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        track = Trackler.tracks.sort_by(&:language).find(&:active?)
        redirect "/stats/%s" % track.id
      end

      get '/stats/:track_id' do |track_id|
        track = Trackler.tracks[track_id]
        unless track.exists?
          redirect '/stats'
        end

        slugs = track.problems.map(&:slug)
        stats = ExercismLib::Stats.new(track.id, slugs)
        datasets = [
          stats,
          ExercismLib::Stats.new(track_id, slugs, ExercismLib::Stats::LastN.new(90)),
          ExercismLib::Stats.new(track_id, slugs, ExercismLib::Stats::LastN.new(120)),
        ] + stats.historical(6)

        erb :"stats/index", locals: {
          tracks: Trackler.tracks.reject {|track| track.problems.count.zero? }.sort_by(&:language),
          track: track,
          datasets: datasets,
        }
      end
    end
  end
end
