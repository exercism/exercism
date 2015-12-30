require_relative '../../x'
class UserProgression

  def self.user_progress(user)
    track_complete_exercises = Hash.new 0
    user.exercises.each{|exe| track_complete_exercises[exe.problem.language] += 1}
    tracks = track_count
    track_complete_exercises.each{|k, v| track_complete_exercises[k] = [v, tracks[k]]}
    track_complete_exercises
  end

  private
  def self.track_count
    Hash[X::Track.all.collect{|t| [t.language, t.problems.count]}]
  end
end
