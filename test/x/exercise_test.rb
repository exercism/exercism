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

    def test_readme
      f = './test/fixtures/xapi_v3_exercise_readme.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        expected = Exercise::Readme.find('fake', 'three')

        assert_equal "Fake", expected.language
        assert_equal "Three", expected.name
        assert_equal "This is three.", expected.blurb
        assert_match "[view source](http://example.com/3)", expected.readme
      end
    end
  end
end
