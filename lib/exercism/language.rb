class Language
  def self.of(key)
    Exercism::Config.tracks[key.to_sym]
  end
end
