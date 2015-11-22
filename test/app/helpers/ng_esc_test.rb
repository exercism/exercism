require_relative '../../test_helper'
require_relative '../../../app/helpers/ng_esc'

class NgEscHelperTest < Minitest::Test
  def helper
    @helper ||= Object.new.extend(ExercismWeb::Helpers::NgEsc)
  end

  def test_escape
    {
      "abc" => "abc",
      "don't worry" => 'don\&apos;t worry',
      'are you "happy"?' => 'are you \&quot;happy\&quot;?',
    }.each do |original, escaped|
      assert_equal escaped, helper.ng_esc(original)
    end
  end
end
