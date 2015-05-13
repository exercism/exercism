require_relative '../app_helper'

class MetadataTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismWeb::App
  end

  def assignments_multiple_files_json
    File.read("./test/fixtures/assignments_multiple_files.json")
  end

  def test_metadata
    Xapi.stub(:get, [200, assignments_multiple_files_json]) do
      get '/exercises/go/leap'
      assert_includes last_response.body, 'file1_content'
      assert_includes last_response.body, 'file2_content'
    end
  end
end
