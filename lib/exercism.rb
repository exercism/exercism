require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/trail'
require 'exercism/assignment'
require 'exercism/curriculum'
require 'exercism/submission'
require 'exercism/nit'
require 'exercism/user'
require 'exercism/use_cases/attempt'
require 'exercism/use_cases/approval'
require 'exercism/use_cases/nitpick'
require 'exercism/use_cases/assignments'

class Exercism

  def self.current_curriculum
    unless @curriculum
      @curriculum = Curriculum.new('./assignments')

      rb = Locale.new('ruby', 'rb', 'rb')
      rb_slugs = %w(
        bob word-count anagram
      )
      @curriculum.add(rb, rb_slugs)

      # javascript
      js = Locale.new('javascript', 'js', 'spec.js')
      js_slugs = %w(
        anagram
      )
      @curriculum.add(js, js_slugs)
    end
    @curriculum
  end

end
