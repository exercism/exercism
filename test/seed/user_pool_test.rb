require './test/test_helper'
require 'faker'
require 'seed/user_pool'

class SeedUserPoolTest < Minitest::Test
  def test_small_pool
    pool = Seed::UserPool.new(3)

    assert_equal [-1, -2, -3], pool.ids
    assert_equal 3, pool.names.size
    assert_equal 3, pool.names.uniq.size
  end

  def test_larger_pool
    pool = Seed::UserPool.new(10)

    expected = [-1, -2, -3, -4, -5, -6, -7, -8, -9, -10]
    assert_equal expected, pool.ids
  end

  def test_random_unique_names
    Faker::Name.stub(:first_name, %w(alice bob charlie).sample) do
      pool = Seed::UserPool.new(20)

      assert_equal 20, pool.names.size
      assert_equal 20, pool.names.uniq.size
    end
  end

  def test_people
    pool = Seed::UserPool.new(3)
    assert_equal 3, pool.people.size
    names = []
    ids = []
    pool.people.each do |person|
      names << person.name
      ids << person.id
    end
    assert_equal pool.names, names
    assert_equal pool.ids, ids
  end
end
