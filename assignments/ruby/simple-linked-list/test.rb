require 'minitest/autorun'
require 'minitest/pride'

require_relative 'linked_list'

class LinkedListTest < MiniTest::Unit::TestCase
  def setup
    @head = linked_list([1])
  end

  def test_head
    assert_equal Element, @head.class
  end

  def test_head_datum
    skip
    assert_equal 1, @head.datum
  end

  def test_add_next
    skip
    @head.next = Element.new(2)

    refute_nil @head.next
    assert_equal Element, @head.next.class
    assert_equal 2, @head.next.datum
  end
end

class LinkedListRangeTest < MiniTest::Unit::TestCase
  def setup
    @head = linked_list((1..10).to_a)
  end

  def test_head_next
    skip
    assert_equal 2, @head.next.datum
  end

  def test_10_deep
    skip
    assert_equal 10, @head.next.next.next.next.next.next.next.next.next.datum
  end
end