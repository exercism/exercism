class Team
  include Mongoid::Document
  field :s, as: :slug, type: String
  has_and_belongs_to_many :members, class_name: "User", inverse_of: :teams
  belongs_to :creator, class_name: "User", inverse_of: :teams_created

  def pg_attributes
    {
      slug: slug,
      mongoid_id: id.to_s,
      mongoid_creator_id: creator_id.to_s
    }
  end
end

class PGTeam < ActiveRecord::Base
  table_name :teams

  has_and_belongs_to_many :members

  # we will need fields for:
  # mongoid_id
  # mongoid_creator_id
end

