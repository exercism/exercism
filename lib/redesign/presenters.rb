module ExercismIO
  module Presenters
    {
      :Carousel => 'carousel',
      :Profile => 'profile',
      :Track => 'track',
      :ExerciseLink => 'exercise_link',
      :Navigation => 'navigation',
      :ActiveExercise => 'active_exercise',
      :Notification => 'notification'
    }.each do |name, file|
      autoload name, Exercism.relative_to_root('lib', 'redesign', 'presenters', file)
    end
  end
end
