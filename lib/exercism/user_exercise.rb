class UserExercise < ActiveRecord::Base
  include Named
  has_many :submissions, ->{ order 'created_at ASC' }

  # I don't really want the notifications method,
  # just the dependent destroy
  has_many :notifications, ->{ where(item_type: 'UserExercise') }, dependent: :destroy, foreign_key: 'item_id', class_name: 'Notification'

  belongs_to :user

  scope :active,    ->{ where(state: ['pending', 'needs_input', 'hibernating']) }
  scope :completed, ->{ where(state: 'done') }

  before_create do
    self.key ||= Exercism.uuid
    true
  end

  def track_id
    language
  end

  # close & reopen:
  # Once v1.0 is launched we can ditch
  # the state on submission.
  def close!
    update_attributes(state: 'done')
    submissions.last.update_attributes(state: 'done')
  end

  def closed?
    state == 'done'
  end

  def reopen!
    update_attributes(state: 'pending')
    submissions.last.update_attributes(state: 'pending')
  end

  def open?
    state == 'pending'
  end

  def unlock!
    update_attributes(is_nitpicker: true)
  end

  def completed?
    state == 'done'
  end

  def hibernating?
    state == 'hibernating'
  end

  def pending?
    state == 'pending'
  end

  def nit_count
    submissions.pluck(:nit_count).sum
  end

  def problem
    @problem ||= Problem.new(track_id, slug)
  end
end
