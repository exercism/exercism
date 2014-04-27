class AcceptanceTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  include Capybara::Assertions

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
