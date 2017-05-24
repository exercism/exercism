module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        if $flipper[:participation_stats].enabled?(current_user)
          tracks = Trackler.tracks.reject {|track| track.implementations.count.zero? }.sort_by(&:language)
          start_date = Date.parse(ParticipationStats::PRE_GAMIFICATION_COMPARISON_DATE)
          end_date = Date.parse(ParticipationStats::GAMIFICATION_EXPERIMENT_END_DATE)
          date_range = start_date..end_date
          stats = {
            experimental: ParticipationStats.new(date_range, gamification_markers: true, experiment_group: :experimental).results,
            control:      ParticipationStats.new(date_range, gamification_markers: true, experiment_group: :control).results
          }
          erb :"stats/participation", locals: {
            tracks: tracks,
            stats: stats,
            experiment_complete_date: (end_date + 1.day).strftime('%A, %b %e, %Y'),
            experiment_completed: ParticipationStats.experiment_complete?,
            user_may_see_early: !current_user.guest? && current_user.motivation_experiment_opt_out?,
          }
        else
          track = Trackler.tracks.sort_by(&:language).find(&:active?)
          redirect "/stats/%s" % track.id
        end
      end

      put '/stats/motivation-experiment-opt-out' do
        unless current_user.guest?
          current_user.update_attribute :motivation_experiment_opt_out, true
        end
        redirect '/stats'
      end

      get '/stats/:track_id' do |track_id|
        track = Trackler.tracks[track_id]
        unless track.exists?
          redirect '/stats'
        end

        slugs = track.implementations.map(&:slug)
        stats = ExercismLib::TrackStats.new(track.id, slugs)
        datasets = [
          stats,
          ExercismLib::TrackStats.new(track_id, slugs, ExercismLib::TrackStats::LastN.new(90)),
          ExercismLib::TrackStats.new(track_id, slugs, ExercismLib::TrackStats::LastN.new(120)),
        ] + stats.historical(6)

        erb :"stats/index", locals: {
          tracks: Trackler.tracks.reject {|track| track.implementations.count.zero? }.sort_by(&:language),
          track: track,
          datasets: datasets,
        }
      end
    end
  end
end
