if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("space_age.exs")
end

ExUnit.start

# You need to define a SpaceAge module containing a function age_on that given a
# planet (:earth, :saturn, etc) and a number of seconds returns the age in years
# on that planet as a floating point number.

defmodule SpageAgeTest do
  use ExUnit.Case, async: true
  doctest SpaceAge

  test "age in earth years" do
    input =  1_000_000_000
    assert_in_delta 31.69, SpaceAge.age_on(:earth, input), 0.005
  end

  test "age_in_mercury_years" do
    input =  2_134_835_688
    assert_in_delta 67.65, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 280.88, SpaceAge.age_on(:mercury, input), 0.005
  end

  test "age_in_venus_years" do
    input = 189_839_836
    assert_in_delta 6.02, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 9.78, SpaceAge.age_on(:venus, input), 0.005
  end

  test "SpaceAge.mars" do
    input = 2_329_871_239
    assert_in_delta 73.83, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 39.25, SpaceAge.age_on(:mars, input), 0.005
  end

  test "SpaceAge.jupiter" do
    input = 901_876_382
    assert_in_delta 28.58, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 2.41, SpaceAge.age_on(:jupiter, input), 0.005
  end

  test "SpaceAge.saturn" do
    input = 3_000_000_000
    assert_in_delta 95.06, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 3.23, SpaceAge.age_on(:saturn, input), 0.005
  end

  test "SpaceAge.uranus" do
    input = 3_210_123_456
    assert_in_delta 101.72, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 1.21, SpaceAge.age_on(:uranus, input), 0.005
  end

  test "SpaceAge.neptune" do
    input = 8_210_123_456
    assert_in_delta 260.16, SpaceAge.age_on(:earth, input), 0.005
    assert_in_delta 1.58, SpaceAge.age_on(:neptune, input), 0.005
  end
end
