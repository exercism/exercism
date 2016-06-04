require_relative '../test_helper'
require 'exercism/excerpt'
require 'nokogiri'

class ExcerptTest < Minitest::Test
  def test_limits_length_for_html
    excerpt = Excerpt.new(<<-EOS)
      <div>
        Thus, programs must be written for
        <i>people to read</i>,
        and only incidentally for machines to execute.
      </div>
    EOS

    assert_equal excerpt.limit(30), 'Thus, programs must be written&hellip;'
  end

  def test_limits_length_for_plain_text
    excerpt = Excerpt.new(<<-EOS)
      Thus, programs must be written for people to read,
      and only incidentally for machines to execute.
    EOS

    assert_equal excerpt.limit(30), 'Thus, programs must be written&hellip;'
  end

  def test_excludes_ellipsis_if_limit_is_longer_than_text_length
    excerpt = Excerpt.new(<<-EOS)
      <div>Hello, world!</div>
    EOS

    assert_equal excerpt.limit(30), 'Hello, world!'
  end
end
