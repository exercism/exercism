require './test/test_helper'
require './test/fixtures/fake_curricula'
require 'seed/trail'
require 'seed/pod'

class Exercism
end

class SeedPodTest < Minitest::Test
  def curricula
    [
      FakePythonCurriculum.new,
      FakeRubyCurriculum.new,
      FakeGoCurriculum.new,
      FakeCurriculum.new
    ]
  end

  def test_random_size
    sizes = (1..100).map do
      Seed::Pod.new(curricula).size
    end
    refute_equal 1, sizes.uniq.size
    refute sizes.include?(0)
    assert sizes.min >= 1, "expected: at least one, got: #{sizes.min}"
    assert sizes.max <= 3, "expected: no more than 3, got: #{sizes.max}"
  end

  def test_random_languages
    languages = (1..100).map do
      Seed::Pod.new(curricula).trails.map { |t| t.language }
    end.flatten.uniq
    assert_equal 4, languages.size
  end

  def test_subset_of_slugs
    sizes = (1..100).map do
      Seed::Pod.new([FakeCurriculum.new]).trails.map { |t| t.slugs.size }
    end.uniq.flatten
    assert_equal [1, 2], sizes.sort
  end
end
