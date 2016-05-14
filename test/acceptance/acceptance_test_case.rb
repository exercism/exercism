class AcceptanceTestCase < Minitest::Test
  include Capybara::DSL
  include Capybara::Assertions
  include DBCleaner

  def create_user(args={ github_id: 123, username: 'some_username' })
    User.create!(args)
  end

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
