class Tag < ActiveRecord::Base
  def self.create_from_text(tags)
    tags.to_s.downcase.split(",").reject(&:blank?).uniq.map do |tag|
      tag = Tag.where(name: tag.strip).first_or_create!
      tag.id
    end
  end
end
