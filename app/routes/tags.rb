module ExercismWeb
  module Routes
    class Tags < Core
      get "/tags" do
        please_login

        tags = Tag.find_by_similarity(params["q"])

        json tags
      end
    end
  end
end
