class ETL

  def self.transform(old)
    data = {}
    old.each do |k, v|
      v.each do |value|
        data[value.downcase] = k
      end
    end
    data
  end

end
