require './test/test_helper'
require 'yaml'
require 'exercism/named'
require 'exercism/readme'

class ReadmeTest < MiniTest::Unit::TestCase
  def test_text
    readme = Readme.new('one', './test/fixtures')
    text = "# One\n\nThis is one.\n\n* one\n* one again\n\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal text, readme.text
  end

  def test_language_specific_text
    readme = Readme.new('one', './test/fixtures', "Setup help.\n")
    text = "# One\n\nThis is one.\n\n* one\n* one again\n\nSetup help.\n\n## Source\n\nThe internet. [view source](http://example.com)\n"
    assert_equal text, readme.text
  end
end
