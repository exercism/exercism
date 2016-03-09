module Stream
  FilterItem = Struct.new(:id, :text, :url, :active, :total) do
    attr_accessor :unread
    alias_method :active?, :active
  end
end
