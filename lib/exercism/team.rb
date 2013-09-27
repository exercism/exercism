class Team
  include Mongoid::Document

  field :s, as: :slug, type: String

  has_and_belongs_to_many :members, class_name: "User", inverse_of: :teams
  belongs_to :creator, class_name: "User", inverse_of: :teams_created

  validates_presence_of :slug
  validates_uniqueness_of :slug

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
