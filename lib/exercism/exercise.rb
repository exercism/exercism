Exercise = Struct.new(:language, :slug) do

  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end

end
