require_relative '../acceptance_helper'

class StaticPageTest < AcceptanceTestCase
  def test_homepage_exists
    visit '/'

    assert_css 'h2', text: 'The devil is in the details'
  end

  def test_about_exists
    Xapi.stub(:get, [200, File.read("./test/fixtures/tracks.json")]) do
      visit '/'
      click_on 'About'
    end

    assert_css 'h1', text: 'About'
  end

  def test_getting_started_exists
    Xapi.stub(:get, [200, File.read("./test/fixtures/tracks.json")]) do
      visit '/'
      click_on 'Welcome'
    end

    assert_css 'h2', text: 'Exercises'
    assert_css 'h2', text: 'Nitpicking'
  end

  def test_donate_exists
    visit '/'
    click_on 'Donate'

    assert_css 'h1', text: 'Donate'
  end

  def test_styleguide_exists
    user = create_user
    with_login(user) do
      visit '/styleguide'

      assert_css 'a', text: 'Styleguide'
    end
  end
end
