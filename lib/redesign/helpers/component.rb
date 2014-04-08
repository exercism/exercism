module ExercismIO
  module Helpers
    module Component
      def sidebar_for(user)
        ExercismIO::Presenters::Navigation.new(user)
      end
    end
  end
end
