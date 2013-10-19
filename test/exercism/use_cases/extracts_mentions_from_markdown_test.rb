require './test/integration_helper'

class ExtractsMentionsFromMarkdownTest < Minitest::Test

  def test_basic_mentions
    user = User.create(username: 'alice')
    content = "Mention @#{user.username}"
    assert_equal [user], ExtractsMentionsFromMarkdown.extract(content)
  end

  def test_ignore_mentions_in_code_spans
    user = User.create(username: 'alice')
    content = "`@#{user.username}`"
    assert_equal [], ExtractsMentionsFromMarkdown.extract(content)
  end

  def test_ignore_mentions_in_fenced_code_blocks
    user = User.create(username: 'alice')
    content = "```\n@#{user.username}\n```"
    assert_equal [], ExtractsMentionsFromMarkdown.extract(content)
  end

  def test_there_are_no_mentions_in_empty_comments
    assert_equal [], ExtractsMentionsFromMarkdown.extract("")
  end

  def test_only_return_mentions_for_existing_usernames
    alice = User.create(username: 'alice')
    content = "Mention @alice and @bob"
    assert_equal [alice], ExtractsMentionsFromMarkdown.extract(content)
  end
end
