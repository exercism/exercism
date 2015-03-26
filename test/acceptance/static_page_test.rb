require_relative '../acceptance_helper'

class StaticPageTest < AcceptanceTestCase
  def test_homepage_exists
    visit '/'

    assert_content "Hootcode"
  end

  def test_about_exists
    Xapi.stub(:get, [200, File.read("./test/fixtures/tracks.json")]) do
      visit '/'
      click_on 'About'
    end

    assert_content 'About'
  end

  def test_getting_started_exists
    Xapi.stub(:get, [200, File.read("./test/fixtures/tracks.json")]) do
      visit '/'
      # click_on 'Welcome'
    end

    assert_content "How it works"
    assert_content "Help"
  end
end
