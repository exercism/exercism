require_relative '../test_helper'
require_relative '../x_helper'
require_relative '../integration_helper'

class UserFinishedTracksTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @user = User.create
    @f = './test/fixtures/xapi_v3_tracks.json'
    create_exercise('animal', 'dog')
    create_exercise('fake', 'hello-world')
    create_exercise('fake', 'two')
    create_exercise('jewels', 'hello-world')
    create_exercise('jewels', 'gemerald')
    create_exercise('shoes','Hello-world')
  end

  def test_user_contributions
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      tracks = UserFinishedTracks.tracks(@user)
      expected = ['animal', 'jewels']
      assert_equal expected, tracks.map(&:id)
    end
  end

  def create_exercise(language, slug)
    UserExercise.create(user: @user, language: language, slug: slug,
                        iteration_count: 1,
                        key: SecureRandom.uuid)
  end
end
