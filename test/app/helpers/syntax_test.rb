require_relative '../../test_helper'
require 'app/helpers/syntax'

class SyntaxHelperTest < Minitest::Test
  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismWeb::Helpers::Syntax)
    @helper
  end

  def test_inline_markdown
  code = <<CODE
"""
```Leap year
Most years are not leap years.
Is a leap year if every year that is evenly divisible by 4.
  Is not a leaper if it is evenly divisible by 100.
    Is a leap year if evenly divisible by 400.
Test driven development forced us to care about most of of the cases right away.
The examples in the test made the read me much clearer.
Python error about module meant to suggest a particular file name.
Pythons logical and operator simpler than Javascript's ampersands.(&)
Exercism readme's structured as nonrepeating text was unclear.
Acceptance criteria for even the most basic cases can be unclear.
Exercism's domain specific language takes some getting used to each time.
```
"""

def is_leap_year(year):
    if year % 4 != 0:
        return False
    elif year % 4 == 0  and year % 400 == 0:
        return True
    elif year % 4 == 0  and year % 100 == 0:
        return False
    return True
CODE

    output = helper.syntax(code, "python")
    refute_match('<p>', output)
  end
end
