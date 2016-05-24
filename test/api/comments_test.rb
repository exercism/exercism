require_relative '../api_helper'

class CommentsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_require_shared_secret
    post '/submissions/abc123/comments'
    assert_equal 401, last_response.status
  end

  def test_only_save_comment_if_rikki_has_not_commented
    alice = User.create(username: 'alice')
    bob = User.create(username: 'bob')
    rikki = User.create(username: 'rikki-')
    submission = Submission.create(user: alice)

    submission.comments.create(user: alice, body: 'abc comment')
    submission.comments.create(user: rikki, body: 'prq comment')
    submission.comments.create(user: bob, body: 'xyz comment')

    assert_equal 3, Comment.count

    Rikki.stub(:shared_key, 'ok') do
      post "/submissions/#{submission.key}/comments?shared_key=ok", { comment: 'a comment' }.to_json
    end

    assert_equal 3, Comment.count
  end
end
