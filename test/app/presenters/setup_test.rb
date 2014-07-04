require_relative '../../test_helper'
require 'app/presenters/setup'
require 'exercism/config'

class SetupPresenterTest < MiniTest::Test
  def with_stubbed_languages(&block)
    Exercism::Config.stub(:languages, {:ruby => 'Ruby'}) do
      Exercism::Config.stub(:upcoming, ["PHP"]) do
        block.call
      end
    end
  end

  def test_current_language
    with_stubbed_languages do
      language = ExercismWeb::Presenters::Setup.new('Ruby')
      assert_equal 'Ruby', language.name
      assert_equal 'ruby', language.topic
      refute language.not_found?
    end
  end

  def test_upcoming_language
    with_stubbed_languages do
      language = ExercismWeb::Presenters::Setup.new('PHP')
      assert_equal 'PHP', language.name
      assert_equal 'coming-soon', language.topic
      refute language.not_found?
    end
  end

  def test_no_such_language
    with_stubbed_languages do
      language = ExercismWeb::Presenters::Setup.new('Fortran')
      assert_equal 'Fortran', language.name
      assert_equal '404', language.topic
      assert language.not_found?
    end
  end
end
