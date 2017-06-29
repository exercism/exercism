module ExercismAPI
  module Routes
    class Stats < Core
      get '/stats/:track_id/activity/recent' do |track_id|
        track = Trackler.tracks[track_id]
        stats = ExercismLib::TrackStats.new(track_id, track.implementations)
        halt 200, { track: { id: track_id, problems: stats.apize } }.to_json
      end
    end
  end
end
