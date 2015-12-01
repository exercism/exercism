require_relative '../test_helper'
require_relative '../x_helper'

module X
  class ProblemTest < Minitest::Test
    def test_test_files
      f= './test/fixtures/xapi_v3_problem_tests.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        _, response = Problem.test_files('ruby', 'saddle-points')
        expected = JSON.parse(response)['exercise']

        assert_equal 'Ruby', expected['language']
        assert_equal 'Saddle Points', expected['name']
        assert_kind_of Hash, expected['files']
      end
    end

    def test_readme
      f = './test/fixtures/xapi_v3_problem_readme.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        _, response = Problem.readme('ruby', 'saddle-points')
        expected = JSON.parse(response)['exercise']

        assert_equal 'Ruby', expected['language']
        assert_equal 'Saddle Points', expected['name']
        assert_kind_of String, expected['readme']
      end
    end
  end
end
