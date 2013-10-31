class Team < ActiveRecord::Base

  belongs_to :creator, class_name: "User"
  has_many :memberships, class_name: "TeamMembership"
  has_many :members, through: :memberships, source: :user

  validates :creator, presence: true
  validates :slug, presence: true,  uniqueness: true

  def self.by(user)
    new(creator: user)
  end

  def defined_with(options)
    self.slug = options[:slug]
    self.members = User.find_in_usernames(options[:usernames].to_s.scan(/\w+/))
    self
  end

  def recruit(usernames)
    self.members += User.find_in_usernames(usernames.to_s.scan(/[\w-]+/))
  end

  def dismiss(username)
    user = User.where(username: username.to_s).first
    self.members.delete(user)
  end

  def usernames
    members.map(&:username)
  end

  def includes?(user)
    creator == user || members.include?(user)
  end
end
