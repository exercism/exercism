require 'faraday'
require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/trail'
require 'exercism/assignment'
require 'exercism/curriculum'
require 'exercism/submission'
require 'exercism/nit'
require 'exercism/comment'
require 'exercism/user'
require 'exercism/guest'
require 'exercism/null_submission'
require 'exercism/completed_exercise'
require 'exercism/markdown'
require 'exercism/authentication'
require 'exercism/github'
require 'exercism/notification'
require 'exercism/use_cases/attempt'
require 'exercism/use_cases/approval'
require 'exercism/use_cases/nitpick'
require 'exercism/use_cases/argument'
require 'exercism/use_cases/assignments'
require 'exercism/use_cases/launch'
require 'exercism/use_cases/notify'
require 'exercism/use_cases/stash'

require 'exercism/curriculum/ruby'
require 'exercism/curriculum/javascript'
require 'exercism/curriculum/coffeescript'
require 'exercism/curriculum/elixir'
require 'exercism/curriculum/clojure'
require 'exercism/curriculum/go'

Mongoid.load!("./config/mongoid.yml")

class Exercism

  def self.current_curriculum
    unless @curriculum
      @curriculum = Curriculum.new('./assignments')

      @curriculum.add RubyCurriculum.new
      @curriculum.add JavascriptCurriculum.new
      @curriculum.add ElixirCurriculum.new
      @curriculum.add ClojureCurriculum.new
    end

    @curriculum
  end

  def self.trails
    @trails ||= current_curriculum.trails.values
  end

end
