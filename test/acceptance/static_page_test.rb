require_relative '../acceptance_helper'

class StaticPageTest < AcceptanceTestCase
  def test_homepage_exists
    visit '/'

    assert page.has_content?('exercism')
  end

  def test_about_exists
    visit '/about'

    assert page.has_content?('About Exercism')
  end
end
