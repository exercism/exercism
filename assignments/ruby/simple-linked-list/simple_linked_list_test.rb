require 'minitest/autorun'

require_relative 'linked_list'

class LinkedListTest < MiniTest::Unit::TestCase
  def setup
    @one = Element.new(1, nil)
    @two = Element.new(2, @one)
  end

  def test_constructor
    assert_equal 1, @one.datum
    assert_nil @one.next

    assert_equal 2, @two.datum
    assert_same @one, @two.next
  end

  def test_to_a
    assert_equal [], Element.to_a(nil)
    assert_equal [1], Element.to_a(@one)
    assert_equal [2, 1], Element.to_a(@two)
  end

  def test_reverse
    # one_r and @one need not be the same object
    one_r = @one.reverse
    assert_equal 1, one_r.datum
    assert_nil one_r.next

    two_r = @two.reverse
    assert_equal 1, two_r.datum
    assert_equal 2, two_r.next.datum

    # ensure that nothing changed about the given objects
    test_constructor
  end

  def test_from_a
    assert_nil Element.from_a([])

    one_a = Element.from_a([1])
    assert_equal 1, one_a.datum
    assert_nil one_a.next

    two_a = Element.from_a([2, 1])
    assert_equal 2, two_a.datum
    assert_equal 1, two_a.next.datum
    assert_nil two_a.next.next

    one_to_ten = Element.from_a(1..10)
    assert_equal 10, one_to_ten.next.next.next.next.next.next.next.next.next.datum
  end

  def test_roundtrip
    assert_equal [1], Element.from_a([1]).to_a
    assert_equal [2, 1], Element.from_a([2, 1]).to_a
    assert_equal (1..10).to_a, Element.from_a(1..10).to_a
  end
end
