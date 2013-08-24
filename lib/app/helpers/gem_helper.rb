class Exercism
  Gem = Struct.new(:major, :minor, :patch)
end

module Sinatra
  module GemHelper
    def gem_version(user_agent)
      match = user_agent.match(/v(\d+)\.(\d+)\.(\d+)(\.beta)?$/)
      Exercism::Gem.new(match[1].to_i, match[2].to_i, match[3].to_i)
    end

    def upgrade_gem?(user_agent)
      if user_agent
        v = gem_version(user_agent)
        v.major == 0 && v.minor == 0 && v.patch < 25
      end
    end
  end
end
