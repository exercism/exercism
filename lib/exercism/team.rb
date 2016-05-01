require './lib/exercism/team_membership'

class Team < ActiveRecord::Base

  has_many :memberships, ->{ where confirmed: true }, class_name: "TeamMembership", dependent: :destroy
  has_many :unconfirmed_memberships, ->{ where confirmed: false }, class_name: "TeamMembership", dependent: :destroy
  has_many :confirmed_memberships, ->{ where confirmed: true }, class_name: "TeamMembership", dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :unconfirmed_members, through: :unconfirmed_memberships, source: :user
  has_many :confirmed_members, through: :confirmed_memberships, source: :user
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

  def destroy_with_memberships!
    TeamMembership.destroy_for_team(self.id)
    self.destroy
  end

  def managed_by?(user)
    managers.include?(user)
  end

  def managed_by(user)
    managers << user unless managed_by?(user)
  end

  def defined_with(options, inviter = nil)
    self.slug = options[:slug]
    self.name = options[:name]
    recruits = User.find_or_create_in_usernames(potential_recruits(options[:usernames])) if options[:usernames]
    recruits = options[:users] if options[:users]

    if recruits
      recruits.each do |recruit|
        TeamMembership.create(user: recruit, team: self, inviter: inviter)
      end
    end

    self
  end

  def recruit(usernames, inviter)
    recruits = User.find_or_create_in_usernames(potential_recruits(usernames.to_s)) - self.all_members

    recruits.each do |recruit|
      TeamMembership.create(user: recruit, team: self, inviter: inviter)
    end
  end

  def dismiss(username)
    user = User.find_by_username(username)
    return if user.nil?

    TeamMembership.where(team_id: self.id, user_id: user.id).map(&:destroy)
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

  def potential_recruits(comma_delimited_names)
    comma_delimited_names.to_s.split(/\s*,\s*/).map(&:strip)
  end

  def normalize_slug
    return unless slug
    self.slug = slug.tr('_', '-').parameterize('-')
  end

  def provide_default_slug
    self.slug ||= self.name
  end

  def provide_default_name
    self.name = self.slug if name.blank?
  end
end
