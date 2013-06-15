# Step 1

def linked_list(ary)
  head = nil
  tail = nil

  ary.each do |datum|
    current_tail = tail
    tail = Element.new(datum)
    current_tail.next = tail unless current_tail.nil?

    if head.nil?
      head = tail
    end
  end

  return head
end

# Step 2

class LinkedList
  attr_reader :head, :tail

  def initialize(list)
    list.each do |datum|
      current_tail = @tail
      @tail = Element.new(datum)
      current_tail.next = @tail unless current_tail.nil?

      if @head.nil?
        @head = @tail
      end
    end
  end

  def head
    @head.datum
  end

  def tail
    @tail.datum
  end

  def [](index)
    index(index).datum
  end

  def index(index)
    current = @head
    index.times do
      current = current.next
    end
    return current
  end

  def add(datum)
    current_tail = @tail
    @tail = Element.new(datum)
    current_tail.next = @tail
  end

  def insert(index, datum)
    previous = index(index-1)
    current = previous.next
    previous.next = Element.new(datum)
    previous.next.next = current
  end

  def delete(index)
    previous = index(index-1)
    previous.next = previous.next.next
  end
end

class Element
  attr_reader :datum
  attr_accessor :next

  def initialize(datum)
    @datum = datum
  end
end