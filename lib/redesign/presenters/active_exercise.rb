require 'forwardable'

module ExercismIO
  module Presenters
    class ActiveExercise
      extend Forwardable
      include Named

      delegate [:slug, :language, :user, :key] => :exercise

      attr_reader :exercise

      def initialize(exercise, notification)
        @exercise = exercise
        @notification = notification
      end

      def read?
        !@notification
      end

      def path
        [user.username, key].join('/')
      end
    end
  end
end
