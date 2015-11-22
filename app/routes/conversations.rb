module ExercismWeb
  module Routes
    class Conversations < Core
      get '/conversations/1' do
        iterations = Explore::Conversation.load("./data/conversations/1.json")
        erb :"site/conversations", locals: {iterations: iterations}
      end
    end
  end
end
