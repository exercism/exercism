require 'flipper'

module Flipper
  module Gates
    class PercentageOfActors
      # Override to consider only the actor value (GitHub username), not the feature
      # name, to provide a consistent control group across features, rather than a
      # different 50% for each feature.
      #
      # Original: https://git.io/vSkAP
      #
      def open?(context)
        percentage = context.values[key]

        if Types::Actor.wrappable?(context.thing)
          actor = Types::Actor.wrap(context.thing)
          key = actor.value ## modified
          Zlib.crc32(key) % 100 < percentage
        else
          false
        end
      end
    end
  end
end
