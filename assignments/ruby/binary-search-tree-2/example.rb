class Bst

  attr_reader :data, :left, :right
  def initialize(data)
    @data = data
  end

  def insert(value)
    if value <= data
      insert_left(value)
    else
      insert_right(value)
    end
  end

  def each(&block)
    left && left.each(&block)
    block.call(data)
    right && right.each(&block)
  end

  private

  def insert_left(value)
    if left
      left.insert(value)
    else
      @left = Bst.new(value)
    end
  end

  def insert_right(value)
    if right
      right.insert(value)
    else
      @right = Bst.new(value)
    end
  end
end
