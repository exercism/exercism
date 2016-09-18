module ExercismWeb
  module Helpers
    module ExPluralizer
      def ex_pluralizer(count, single, plural=nil)
        if count == 1
          "#{count} #{single}"
        elsif plural
          "#{count} #{plural}"
        else
          "#{count} #{single}s"
        end
      end
    end
  end
end
