require './test/test_helper'
require 'exercism/article'
require 'app/helpers/article_helper'

class ArticleHelperTest < MiniTest::Unit::TestCase

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::ArticleHelper)
    def @helper.article_dir
      './test/fixtures/articles'
    end
    @helper
  end

  def test_article
    article = helper.article('section', 'whatever', {'BULLSHIT' => 'stuff'})
    expected = "## So much stuff\n\nThat's what you get, though.\n"
    assert_equal expected, article.to_s
  end

end
