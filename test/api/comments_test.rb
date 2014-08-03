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

  def test_saves_comment_without_affecting_nit_count
    rikki = User.create(username: 'rikki-')
    user = User.create(username: 'alice')
    submission = Submission.create(user: user)
    Rikki.stub(:shared_key, 'ok') do
      post "/submissions/#{submission.key}/comments", shared_key: 'ok', body: 'comment'
    end

    comment = Comment.first
    assert_equal "comment", comment.body
    assert_equal rikki.id, comment.user_id
    assert_equal 0, submission.reload.nit_count
  end
end
