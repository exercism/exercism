require_relative '../test_helper'
require_relative '../../lib/exercism/language'

class LanguageTest < Minitest::Test
  def test_language_name
    assert_equal 'C++', Language.of('cpp')
    assert_equal 'C#', Language.of(:csharp)
  end
end
