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

      def path
        ['', username, exercise.key].join('/')
      end
    end
  end
end
