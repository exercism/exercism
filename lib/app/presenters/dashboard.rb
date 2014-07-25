module ExercismWeb
  module Presenters
    class Dashboard
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def pay_it_forward?
        !!suggestion
      end

      def suggestion
        @suggestion ||= Work.new(user).random
      end

      def has_activity?
        notifications.count > 0
      end

      def notifications
        @notifications ||= user.notifications.unread.personal
      end

      def progress_bar
        case user.onboarding_steps.last
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
         <span class='progress-text'>Install CLI</span></li>
         <li><span class='progress-text'>Submit Code</span></li>
         <li><span class='progress-text'>Have a Conversation</span></li>
         <li><span class='progress-text'>Pay it Forward</span></li>")
      end

      def one_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'>Install CLI</span></li>
         <li class='active'><span class='progress-text'>Submit Code</span></li>
         <li><span class='progress-text'>Have a Conversation</span></li>
         <li><span class='progress-text'>Pay it Forward</span></li>")
      end

      def two_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'>Install CLI</span></li>
         <li class='visited'><span class='progress-text'>Submit Code</span></li>
         <li class='active'><span class='progress-text'>Have a Conversation</span></li>
         <li><span class='progress-text'>Pay it Forward</span></li>")
      end

      def three_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'>Install CLI</span></li>
         <li class='visited'><span class='progress-text'>Submit Code</span></li>
         <li class='visited'><span class='progress-text'>Have a Conversation</span></li>
         <li class='active'><span class='progress-text'>Pay it Forward</span></li>")
      end

      def four_fill
        progress_bar_outer("<li class='first visited'>
         <span class='progress-text'>Install CLI</span></li>
         <li class='visited'><span class='progress-text'>Submit Code</span></li>
         <li class='visited'><span class='progress-text'>Have a Conversation</span></li>
         <li class='last visited'><span class='progress-text'>Pay it Forward</span></li>")
      end
    end
  end
end
