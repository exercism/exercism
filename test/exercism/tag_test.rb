require_relative '../integration_helper'

class TagTest < Minitest::Test
  include DBCleaner

  def test_create_tags_from_text
    assert_equal 0, Tag.count
    values = Tag.create_from_text('implementing, tags, for, teams')
    assert_equal 4, Tag.count
    assert_equal 4, values.size
  end

  def test_create_tags_from_text_ignores_empty_tags
    assert_equal 0, Tag.count
    values = Tag.create_from_text('test,,empty, , tags')
    assert_equal 3, Tag.count
    assert_equal 3, values.size
  end

  def test_create_tags_from_text_uses_existing_tags
    Tag.create_from_text('old, tag')
    assert_equal 2, Tag.count

    values = Tag.create_from_text('new, tag')
    assert_equal 3, Tag.count
    assert_equal 2, values.size
  end

  def test_find_by_similarity
    Tag.create_from_text('ruby, python, elixir, elixirscript')

    tags = Tag.find_by_similarity('elix')
    assert_equal 2, tags.size
    assert_includes tags, 'elixir'
    assert_includes tags, 'elixirscript'
  end

  def test_find_by_similarity_sort_tags_by_relevance
    Tag.create_from_text('ruby, rubinius, random')

    tags = Tag.find_by_similarity('rub')
    assert tags == ['ruby', 'rubinius']
  end
end
