module ExercismWeb
  module Presenters
    class Profile

      DEFAULTS = { shared: false }

      def initialize(user, current_user=user, options={})
        @user = user
        @current_user = current_user
        @options = DEFAULTS.merge(options)
      end

      def username
        user.username
      end

      def shared?
        @options[:shared]
      end

      def exercises
        @exercises ||= user.exercises.where(archived: false).where('iteration_count > 0')
      end

      def progress_hash
        UserProgression.user_progress(user).sort_by(&:last_updated)
      end

      def archived_exercises
        @archived_exercises ||= user.exercises.where(archived: true).where('iteration_count > 0')
      end

      def can_access?(exercise)
        shared? || current_user.can_access?(exercise)
      end

      def has_current_exercises?
        exercises.count > 0
      end

      def has_archived_exercises?
        archived_exercises.count > 0
      end

      def teams
        user.unconfirmed_teams | user.teams | user.managed_teams
      end

      def has_teams?
        teams.any?
      end

      def has_share_key?
        user.share_key
      end

      def archived_in(track_id)
        archived_exercises.where(language: track_id).reverse
      end

      def track_ids
        @track_ids ||= archived_exercises.pluck('language').uniq
      end

      def is_track_mentor?
        user.track_mentor.any?
      end

      def mentored_tracks
        user.track_mentor
      end

      attr_reader :user, :current_user
    end
  end
end
