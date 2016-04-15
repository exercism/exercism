require_relative '../test_helper'
require_relative '../x_helper'

module X
  class ExerciseTest < Minitest::Test
    def test_test_files
      f= './test/fixtures/xapi_v3_exercise_test_files.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        expected = Exercise::TestFiles.find('animal', 'dog')
        expected_files = {
          "a_dog.animal"=>"assert 'woof woof'\n",
          "a_dog_2.animal"=>"assert \"Miaowww\"\n"
        }
        assert_equal "Animal", expected.language
        assert_equal "Dog", expected.name
        assert_equal "This is dog.", expected.blurb
        assert_equal expected_files, expected.files
      end
    end
  end
end
