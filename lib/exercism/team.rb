require './lib/exercism/team_membership'
require './lib/exercism/team_membership_invite'

class Team < ActiveRecord::Base
  has_many :memberships, -> { where confirmed: true }, class_name: "TeamMembership", dependent: :destroy
  has_many :membership_invites, -> { where refused: false }, class_name: "TeamMembershipInvite", dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :member_invites, through: :membership_invites, source: :user
  has_many :management_contracts, class_name: "TeamManager"
  has_many :managers, through: :management_contracts, source: :user

  validates :slug, presence: true, uniqueness: true

  before_validation :provide_default_name, :provide_default_slug, :normalize_slug

  def self.by(user)
    team = new
    team.managers << user
    team
  end

  def self.find_by_slug(slug)
    where('LOWER(slug) = ?', slug.downcase).first
  end

  def self.search_public
    where("public = true")
  end

  def self.search_public_with_tag(tag)
    return [] if tag.blank?
    search_public.where("tags @> ARRAY[?]", tag)
  end

  def destroy_with_memberships!
    TeamMembership.destroy_for_team(id)
    destroy
  end

  def managed_by?(user)
    managers.include?(user)
  end

  def managed_by(user)
    managers << user unless managed_by?(user)
  end

  # rubocop:disable Metrics/AbcSize
  def defined_with(options, inviter=nil)
    self.slug = options[:slug]
    self.name = options[:name]
    self.description = options[:description]
    self.public = options[:public].present?

    tags = [options[:slug], options[:name], options[:tags]].join(',')
    self.tags = Tag.create_from_text(tags)

    users = User.find_or_create_in_usernames(potential_members(options[:usernames])) if options[:usernames]
    users = options[:users] if options[:users]
    invite(users, inviter)

    self
  end

  def invite_with_usernames(usernames, inviter)
    invite(
      User.find_or_create_in_usernames(potential_members(usernames)),
      inviter
    )
  end

  def invite(users, inviter)
    return unless users.present?

    users = Array(users) - all_members

    users.each do |user|
      TeamMembershipInvite.create(user: user, team: self, inviter: inviter, refused: false)
    end
  end

  def dismiss(username)
    user = User.find_by_username(username)
    return if user.nil?

    TeamMembership.where(team_id: id, user_id: user.id).map(&:destroy)
    members.delete(user)
  end

  def usernames
    members.map(&:username)
  end

  def includes?(user)
    managers.include?(user) || members.include?(user)
  end

  def all_members
    members + member_invites
  end

  def all_tags
    Tag.where(id: tags).pluck(:name).join(', ')
  end

  private

  def potential_members(comma_delimited_names)
    comma_delimited_names.to_s.split(/\s*,\s*/).map(&:strip)
  end

  def normalize_slug
    return unless slug
    self.slug = slug.tr('_', '-').parameterize('-')
  end

  def provide_default_slug
    self.slug ||= name
  end

  def provide_default_name
    self.name = self.slug if name.blank?
  end
end
