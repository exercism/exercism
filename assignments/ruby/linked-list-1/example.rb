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

class Element
  attr_reader :datum
  attr_accessor :next

  def initialize(datum)
    @datum = datum
  end
end