require_relative '../../x'

class UserTracksSummary
  def self.call(user)
    new(user).tracks_summary
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def tracks_summary
    @tracks_summary ||= languages_contributed.map do |lan|
      TrackSummary.new(lan, total_contribution_by_language(lan))
    end
  end

  private

  def languages_contributed
    @languages_contributed ||= completed_exercises_hash.keys.concat(reviewed_exercises_hash.keys).uniq
  end

  def total_contribution_by_language(language)
    completed = completed_exercises_hash[language] || {}
    reviewed = reviewed_exercises_hash[language] || {}
    completed.merge(reviewed)
  end

  def completed_exercises_hash
    @completed_exercises_hash ||= Hash[completed_exercises_by_language.map do |lan, exercises|
      [lan, { completed: exercises.size }]
    end
    ]
  end

  def reviewed_exercises_hash
    @reviewed_exercises_hash = Hash[reviewed_exercises_by_language.map do |lan, reviewed|
      [lan, { reviewed: reviewed.size }]
    end
    ]
  end

  def completed_exercises_by_language
    @completed_exercises_by_language ||= user.exercises.completed.group_by(&:language)
  end

  def reviewed_exercises_by_language
    @reviewed_exercises_by_language ||= user.comments.group_by { |c| c.submission.language }
  end

  class TrackSummary
    attr_reader :language, :track_info
    def initialize(language, track_info)
      @language = language
      @track_info = track_info
    end

    def completed?
      completed.present? ? true : false
    end

    def completed
      @completed ||= track_info[:completed]
    end

    def reviewed?
      reviewed.present? ? true : false
    end

    def reviewed
      @reviewed ||= track_info[:reviewed]
    end

    def track
      @track ||= X::Track.find(language)
    end
  end
end
