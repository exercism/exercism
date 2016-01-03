module ExercismWeb
  module Presenters
    class Dashboard
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def current_exercises
        user.exercises.current.order(:language)
      end

      def unsubmitted_exercises
        user.exercises.unsubmitted
      end

      def has_activity?
        notifications.count > 0
      end

      def notifications
        @notifications ||= user.notifications.unread.personal
      end

      def status
        @status ||= Onboarding.status(user.onboarding_steps)
      end

      def next_action
        Onboarding.next_action(user.onboarding_steps)
      end

      def progress_bar
        case status
        when "joined"            then no_fill
        when "fetched"           then one_fill
        when "submitted"         then two_fill
        when "received_feedback" then two_fill
        when "completed"         then three_fill
        when "commented"         then four_fill
        else
          ""
        end
      end

      private

      def progress_bar_outer(inner)
        "<div class='progress-bar-wrap'>
          <ul class='progress-bar'>
        #{inner}
          </ul>
        </div>"
      end

      def no_fill
        progress_bar_outer("<li class='first'>
         <span class='progress-text'><a href='../onboarding/joined'>Install CLI</a></span></li>
         <li><span class='progress-text'><a href='../onboarding/'>Submit Code</a></span></li>
         <li><span class='progress-text'><a href='../onboarding/received_feedback'>Have a Conversation</a></span></li>
         <li><span class='progress-text'><a href='../onboarding/submitted'>Pay it Forward</a></span></li>")
      end

      def one_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'><a href='../onboarding/joined'>Install CLI</a></span></li>
         <li class='active'><span class='progress-text'><a href='../onboarding/'>Submit Code</a></span></li>
         <li><span class='progress-text'><a href='../onboarding/received_feedback'>Have a Conversation</a></span></li>
         <li><span class='progress-text'><a href='../onboarding/submitted'>Pay it Forward</a></span></li>")
      end

      def two_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'><a href='../onboarding/joined'>Install CLI</a></span></li>
         <li class='visited'><span class='progress-text'><a href='../onboarding/'>Submit Code</a></span></li>
         <li class='active'><span class='progress-text'><a href='../onboarding/received_feedback'>Have a Conversation</a></span></li>
         <li><span class='progress-text'><a href='../onboarding/submitted'>Pay it Forward</a></span></li>")
      end

      def three_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'><a href='../onboarding/joined'>Install CLI</a></span></li>
         <li class='visited'><span class='progress-text'><a href='../onboarding/'>Submit Code</a></span></li>
         <li class='visited'><span class='progress-text'><a href='../onboarding/received_feedback'>Have a Conversation</a></span></li>
         <li class='active'><span class='progress-text'><a href='../onboarding/submitted'>Pay it Forward</a></span></li>")
      end

      def four_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'><a href='../onboarding/joined'>Install CLI</a></span></li>
         <li class='visited'><span class='progress-text'><a href='../onboarding/'>Submit Code</a></span></li>
         <li class='visited'><span class='progress-text'><a href='../onboarding/received_feedback'>Have a Conversation</a></span></li>
         <li class='last visited'><span class='progress-text'><a href='../onboarding/submitted'>Pay it Forward</a></span></li>")
      end
    end
  end
end
