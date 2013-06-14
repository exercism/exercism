class Array
  def accumulate
    result = []
    each do |e|
      result << yield(e)
    end
    result
  end
end
