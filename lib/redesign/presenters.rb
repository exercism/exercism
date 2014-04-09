module ExercismIO
  module Presenters
    {
      :Carousel => 'carousel',
      :Languages => 'languages',
      :Profile => 'profile',
      :Track => 'track',
      :ExerciseLink => 'exercise_link',
      :Navigation => 'navigation',
      :ActiveExercise => 'active_exercise',
      :Notification => 'notification'
    }.each do |name, file|
      autoload name, [ExercismIO::ROOT, 'presenters', file].join('/')
    end
  end
end
