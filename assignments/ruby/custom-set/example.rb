class CustomSet
  attr_reader :data

  def initialize(input_data = [])
    @data = parse_data(input_data)
  end

  def delete(datum)
    data.each do |n|
      @data -= Array(n) if n.datum.eql?(datum)
    end
    self
  end

  def difference(other)
    shared = nodes - other.nodes
    CustomSet.new(shared)
  end

  def disjoint?(other)
    remainder = nodes - other.nodes
    remainder.length == data.length
  end

  def empty
    CustomSet.new
  end

  def intersection(other)
    intersection = nodes.select do |node|
      other.nodes.any?{ |other_node| other_node.eql?(node) }
    end
    CustomSet.new(intersection)
  end

  def member?(datum)
    data.any?{ |node| node.datum.eql?(datum) }
  end

  def put(datum)
    unless data.any? { |node| node.datum.eql?(datum) }
      add_datum(datum)
    end
    self
  end

  def size
    nodes.uniq.count
  end

  def subset?(other)
    return true if other.data.empty?
    other.nodes.all?{ |other_node| nodes.any?{|node| node.eql?(other_node) } }
  end

  def to_list
    nodes.uniq
  end

  def union(other)
    union = (nodes + other.nodes).uniq
    CustomSet.new(union)
  end

  def ==(other)
    nodes == other.nodes
  end

  def nodes
    data.map{|d| d.datum}.sort
  end

  def add_datum(datum)
    @data << Node.new(datum)
  end

  private

  def parse_data(input_data)
    input_data.map do |d|
      Node.new(d)
    end
  end

end

class Node
  attr_reader :datum

  def initialize(input_datum)
    @datum = input_datum
  end

end