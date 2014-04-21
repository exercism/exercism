require_relative '../../test_helper'
require 'exercism'
require 'exercism/article'
require 'redesign/helpers/article'

class ArticleHelperTest < MiniTest::Unit::TestCase

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismIO::Helpers::Article)
    def @helper.article_dir
      Exercism.relative_to_root('test', 'fixtures', 'articles')
    end
    @helper
  end

  def test_article
    article = helper.article('section', 'whatever', {'BULLSHIT' => 'stuff'})
    expected = "## So much stuff\n\nThat's what you get, though.\n"
    assert_equal expected, article.to_s
  end

end
