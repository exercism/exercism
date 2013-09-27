require './test/test_helper'
require 'api/helpers/gem_helper'

class GemHelperTest < Minitest::Test

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::GemHelper)
    @helper
  end

  def test_version
    user_agent = "github.com/kytrinyx/exercism CLI v0.0.24"
    version = helper.gem_version(user_agent)
    assert 0, version.major
    assert 0, version.minor
    assert 24, version.patch
  end

  def test_version_handles_beta_versions
    user_agent = "github.com/kytrinyx/exercism CLI v0.0.25.beta"
    version = helper.gem_version(user_agent)
    assert 0, version.major
    assert 0, version.minor
    assert 25, version.patch
  end

  def test_upgrade_please
    user_agent = "github.com/kytrinyx/exercism CLI v0.0.24"
    assert helper.upgrade_gem?(user_agent)

    user_agent = "github.com/kytrinyx/exercism CLI v0.0.25"
    refute helper.upgrade_gem?(user_agent)

    user_agent = "github.com/kytrinyx/exercism CLI v0.0.26.beta"
    refute helper.upgrade_gem?(user_agent)
  end
end
