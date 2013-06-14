class Array
  def keep
    kept = []
    each {|e| kept << e if yield(e)}
    kept
  end

  def discard
    discarded = []
    each {|e| discarded << e unless yield(e)}
    discarded
  end
end
