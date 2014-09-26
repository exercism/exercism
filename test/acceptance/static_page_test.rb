require_relative '../acceptance_helper'

class StaticPageTest < AcceptanceTestCase
  def test_homepage_exists
    visit '/'

    assert_content 'exercism'
  end

  def test_about_exists
    visit '/'
    click_on 'About'

    assert_content 'About'
  end

  def test_getting_started_exists
    visit '/'
    click_on 'Welcome'

    assert_content 'Exercises'
    assert_content 'Nitpicking'
  end
end
