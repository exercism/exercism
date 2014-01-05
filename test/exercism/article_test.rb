require './test/test_helper'
require 'exercism/article'
require 'exercism/converts_markdown_to_html'

class ArticleTest < MiniTest::Unit::TestCase
  def test_variable_replacement
    article = Article.new('This {{THING}} sucks!', 'THING' => 'stuff')
    assert_equal 'This stuff sucks!', article.to_s
  end

  def test_markdown_conversion
    article = Article.new('Go!')
    assert_equal '<p>Go!</p>', article.to_html
  end
end
