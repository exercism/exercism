require 'delegate'

module ExercismWeb
  module Presenters
    class Look < SimpleDelegator

      def self.wrap(looks)
        looks.map {|look| new(look)}
      end

      def username
        exercise.user.username
      end

      def language
        exercise.language
      end

      def name
        exercise.name
      end

      def path
        ['', username, exercise.key].join('/')
      end
    end
  end
end
