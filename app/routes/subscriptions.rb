module ExercismWeb
  module Routes
    class Subscriptions < Core
      put '/subscriptions/iterations/:uuid' do |uuid|
        url = ["", "submissions", uuid].join("/")

        if current_user.guest?
          flash[:error] = "Cannot update subscriptions without logging in."
          redirect url
        end

        iteration = Submission.find_by_key(uuid)
        if iteration.nil?
          flash[:error] = "Iteration not found."
          redirect '/'
        end

        case params[:subscribe].to_s.downcase
        when "1", "true", "yes", "y"
          ConversationSubscription.subscribe(current_user, iteration)
        when "0", "false", "no", "n"
          ConversationSubscription.unsubscribe(current_user, iteration)
        # rubocop:disable Style/EmptyElse
        else
          # inconclusive, don't change anything
        end # rubocop:enable Style/EmptyElse
        redirect url
      end
    end
  end
end
