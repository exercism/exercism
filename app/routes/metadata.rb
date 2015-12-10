require_relative '../../x'

module ExercismWeb
  module Routes
    class Metadata < Core
      get '/exercises/:track_id/:slug' do |id, slug|
        exercise = X::Exercise::TestFiles.find(id, slug)
        if exercise.files.empty?
          flash[:notice] = error_message(exercise)
          redirect '/'
        end
        erb :"exercises/test_suite", locals: { exercise: exercise }
      end

      get '/exercises/:track_id/:slug/readme' do |id, slug|
        exercise = X::Exercise::Readme.find(id, slug)
        if exercise.readme.empty?
          flash[:notice] = error_message(exercise)
          redirect '/'
        end
        erb :"exercises/readme", locals: { exercise: exercise }
      end

      private

      def error_message(exercise)
        "No files for #{exercise.name} problem in #{exercise.language} track"
      end
    end
  end
end
