module ExercismWeb
  module Routes
    class Metadata < Core
      get '/exercises/:track_id/:slug' do |track_id, slug|
        status, response = Xapi.get("assignments", track_id, slug)
        data = JSON.parse(response)
        if status == 404
          flash[:notice] = data['error']
          redirect '/'
        end
        data = data["assignments"].first
        problem = Problem.new(data['track'], data['slug'])
        text = data["files"].find {|filename, _|
          filename =~ /test/i || filename =~ /\.t$/ || filename =~ /ut_.*#\.plsql\Z/}.last
        erb :"exercises/test_suite", locals: {problem: problem, text: text}
      end

      get '/exercises/:track_id/:slug/readme' do |track_id, slug|
        status, response = Xapi.get("assignments", track_id, slug)
        data = JSON.parse(response)
        if status == 404
          flash[:notice] = data['error']
          redirect '/'
        end
        data = data["assignments"].first
        problem = Problem.new(data['track'], data['slug'])
        text = data["files"].find {|key, _| key == "README.md"}.last
        erb :"exercises/readme", locals: {problem: problem, text: text}
      end
    end
  end
end
