class AcceptanceTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  include Capybara::Assertions
  include DBCleaner

  def with_login(user)
    Authentication.stub(:perform, user) do
      visit '/github/callback?code=something'

      yield
    end
  end

  def teardown
    super
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
