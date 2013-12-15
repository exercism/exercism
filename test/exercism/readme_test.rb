require './test/test_helper'
require 'yaml'
require 'exercism/readme'

class ReadmeTest < Minitest::Test
  def test_text
    readme = Readme.new('one', './test/fixtures')
    text = "# One\n\nThis is one.\n\n* one\n* one again\n\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal text, readme.text
  end
end
