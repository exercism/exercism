require 'forwardable'

module App
  module User
    class ActiveExercise
      extend Forwardable

      def_delegators :exercise,
        :slug, :language, :user, :key

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
