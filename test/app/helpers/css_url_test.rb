require_relative '../../test_helper'
require_relative '../../../app/helpers/css_url'

class CssUrlHelperTest < Minitest::Test
  class FakeApplication
    def settings
      Struct.new(:public_folder).new('fake_public_folder')
    end
  end

  def helper
    FakeApplication.new.extend ExercismWeb::Helpers::CssUrl
  end

  def test_application_css_exists
    fake_timestamp = '123456789'
    File.stub(:exist?, true) do
      File.stub(:mtime, fake_timestamp) do
        assert_equal "/css/application.css?t=#{fake_timestamp}", helper.css_url
      end
    end
  end

  def test_application_css_nonexistant
    expected_error_message = <<-MESSAGE.gsub(/^ */, '')
    'fake_public_folder/css/application.css' not found.
    Try running 'bundle exec compass compile' to generate it.
    For more information: https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md#scss
    MESSAGE

    File.stub(:exists?, false) do
      error = assert_raises IOError do
        helper.css_url
      end
      assert_equal expected_error_message, error.message
    end
  end
end
