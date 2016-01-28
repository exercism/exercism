require_relative '../../x'
class UserProgression

  def self.user_progress(user)
    track_complete_exercises = Hash.new 0
    user.exercises.where("language<>''").where('iteration_count > 0').each{|exe| track_complete_exercises[exe.problem.language] += 1}
    tracks = track_counts
    track_complete_exercises.each{|k, v| track_complete_exercises[k] = [v, tracks[k]]}
    track_complete_exercises
  end

  def self.track_counts
    Hash[X::Track.all.collect{|t| [t.language, t.problems.count]}]
  end
end
