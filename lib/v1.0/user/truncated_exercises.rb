module App
  module User
    module TruncatedExercises
      def self.by_track(exercises)
        exercises.group_by(&:language).map do |language, exercises|
          App::User::Track.new(language, exercises.map {|e| App::User::Exercise.new(e)})
        end
      end
    end
  end
end
