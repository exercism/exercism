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

  private

  def insert_right(value)
    if right
      right.insert(value)
    else
      @right = Bst.new(value)
    end
  end

  def insert_left(value)
    if left
      left.insert(value)
    else
      @left = Bst.new(value)
    end
  end

end

__END__

# maybe refactor to this
class Bst
  Null = Object.new

  def Null.insert(data)
    Bst.new data
  end

  def Null.each
  end

  attr_accessor :data, :left, :right

  def initialize(data)
    self.data  = data
    self.left = self.right = Null
  end

  def insert(new_data)
    if new_data <= data
      self.left = left.insert new_data
    else
      self.right = right.insert new_data
    end
    self
  end

  def each(&block)
    left.each(&block)
    block.call data
    right.each(&block)
  end
end
