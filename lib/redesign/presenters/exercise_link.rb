require 'delegate'

module ExercismIO
  module Presenters
    class ExerciseLink < SimpleDelegator
      include Named

      def url
        File.join('/', user.username, key)
      end

    end
  end
end
