module ExercismWeb
  module Routes
    class Metadata < Core
      get '/exercises/:track_id/:slug' do |track_id, slug|
        status, response = Xapi.get("v2", "exercises", track_id, slug)
        data = JSON.parse(response)
        if status == 404
          flash[:notice] = data['error']
          redirect '/'
        end

        locals = Presenters::Assignment.from_json_data(data).to_locals
        erb :"exercises/test_suite", locals: locals
      end

      get '/exercises/:track_id/:slug/readme' do |track_id, slug|
        status, response = Xapi.get("v2", "exercises", track_id, slug)
        data = JSON.parse(response)
        if status == 404
          flash[:notice] = data['error']
          redirect '/'
        end

        locals = Presenters::Assignment.from_json_data(data).to_locals
        erb :"exercises/readme", locals: locals
      end
    end
  end
end
