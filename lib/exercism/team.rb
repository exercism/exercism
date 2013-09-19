class Team
  include Mongoid::Document

  field :s, as: :slug, type: String

  has_and_belongs_to_many :members, class_name: "User", inverse_of: :teams
  belongs_to :creator, class_name: "User", inverse_of: :teams_created

  validates_uniqueness_of :slug

  def members_with_pending_submissions
    @members_with_pending_submissions ||= members.select do |member|
      member.latest_submission
    end
  end
end
