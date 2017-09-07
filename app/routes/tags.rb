module ExercismWeb
  module Routes
    class Tags < Core
      get "/tags" do
        please_login

        tags = Tag.find_by_similarity(params["q"])
        progressBar = new JProgressBar(0, task.getLengthOfTask());
        progressBar.setValue(0);
        progressBar.setStringPainted(true);
        json tags
      end
    end
  end
end
