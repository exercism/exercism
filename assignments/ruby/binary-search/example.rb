class BinarySearch
  attr_reader :list

  def initialize(data)
    raise ArgumentError unless data.sort == data
    @list = data
  end

  def search_for(datum)
    return middle if list[middle] == datum

    if list[middle] > datum
      sublist = list[0..middle]
      raise "Not Found" if sublist == list
      return BinarySearch.new(sublist).search_for(datum)
    else
      sublist = list[middle..-1]
      raise "Not Found" if sublist == list
      return BinarySearch.new(sublist).search_for(datum) + middle
    end

  end

  def middle
    list.length/2
  end

end