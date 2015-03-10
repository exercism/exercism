class Team < ActiveRecord::Base

  has_many :memberships, ->{ where confirmed: true }, class_name: "TeamMembership"
  has_many :unconfirmed_memberships, ->{ where confirmed: false }, class_name: "TeamMembership"
  has_many :members, through: :memberships, source: :user
  has_many :unconfirmed_members, through: :unconfirmed_memberships, source: :user
  has_many :management_contracts, class_name: "TeamManager"
  has_many :managers, through: :management_contracts, source: :user

  validates :slug, presence: true,  uniqueness: true

  before_validation :provide_default_name, :provide_default_slug, :normalize_slug

  def self.by(user)
    team = new
    team.managers << user
    team
  end

  def self.find_by_slug(slug)
    where('LOWER(slug) = ?', slug.downcase).first
  end

  def managed_by?(user)
    managers.include?(user)
  end

  def managed_by(user)
    managers << user unless managed_by?(user)
  end

  def defined_with(options)
    self.slug = options[:slug]
    self.name = options[:name]
    self.unconfirmed_members << User.find_or_create_in_usernames(options[:usernames].to_s.scan(/\w+/)) if options[:usernames]
    self.unconfirmed_members << options[:users] if options[:users]
    self
  end

  def recruit(usernames)
    recruits = User.find_or_create_in_usernames(usernames.to_s.scan(/[\w-]+/)) - self.all_members
    self.unconfirmed_members += recruits
  end

  def dismiss(username)
    user = User.find_by_username(username)
    self.members.delete(user)
    self.unconfirmed_members.delete(user)
  end

  # TODO: let's confirm on user, not username, since
  # we can't report errors if we don't find the user or they're already a member.
  def confirm(username)
    user = User.find_by_username(username)
    member = unconfirmed_memberships.where(user_id: user.id).first
    if member
      member.confirm!
      self.unconfirmed_members.reload
      self.members.reload
    end
  end

  def usernames
    members.map(&:username)
  end

  def includes?(user)
    managers.include?(user) || members.include?(user)
  end

  def all_members
    members + unconfirmed_members
  end

  private

  def normalize_slug
    return unless slug
    self.slug = slug.gsub('_', '-').parameterize('-')
  end

  def provide_default_slug
    self.slug ||= self.name
  end

  def provide_default_name
    self.name = self.slug if name.blank?
  end
end
