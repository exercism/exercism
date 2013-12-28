module Named
  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end
end
