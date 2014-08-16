module ExercismWeb
  module Routes
    class Metadata < Core
      get '/exercises/:track_id/:slug' do |track_id, slug|
        _, response = Xapi.get("assignments", track_id, slug)
        data = JSON.parse(response)["assignments"].first
        problem = Problem.new(data['track'], data['slug'])
        text = data["files"].find {|filename, code| filename =~ /test/i || filename =~ /\.t$/}.last
        erb :"exercises/test_suite", locals: {problem: problem, text: text}
      end

      get '/exercises/:track_id/:slug/readme' do |track_id, slug|
        _, response = Xapi.get("assignments", track_id, slug)
        data = JSON.parse(response)["assignments"].first
        problem = Problem.new(data['track'], data['slug'])
        text = data["files"].find {|key, value| key == "README.md"}.last
        erb :"exercises/readme", locals: {problem: problem, text: text}
      end
    end
  end
end
