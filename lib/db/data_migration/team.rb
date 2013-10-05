class Team
  include Mongoid::Document
  field :s, as: :slug, type: String
  belongs_to :creator, class_name: "User"

  has_and_belongs_to_many :members, class_name: "User"

  # There are no timestamps in teams.
  # It's OK, because there aren't too many of them.
  def self.unmigrated
    not_in(id: PGTeam.migrated_ids)
  end

  def pg_creator
    @pg_creator ||= PGUser.find_by_mongoid_id(creator_id.to_s)
  end

  def pg_attributes
    {
      slug: slug,
      creator_id: pg_creator.id,
      mongoid_id: id.to_s,
      mongoid_creator_id: creator_id.to_s
    }
  end
end

class PGTeam < ActiveRecord::Base
  self.table_name = :teams

  def self.migrated_ids
    where('1=1').pluck(:mongoid_id)
  end
end

class TeamMembership < ActiveRecord::Base
end

