require 'app/presenters/problems'

module ExercismWeb
  module Routes
    class Languages < Core
      get '/languages' do
        erb :"languages/all"
      end

      get '/languages/:track_id' do |track_id|
        language = Language.of(track_id)

        begin
          active = ExercismWeb::Presenters::Tracks.find(track_id.to_s).active?
        rescue => e
          Bugsnag.notify(e, nil, request)
          return erb:"languages/not_implemented", locals: { language: language }
        end

        return erb :"languages/in_progress", locals: { language: language, slug: track_id } if !active

        problems = Presenters::Special::Problems.new(track_id).track_problems
        docs = Presenters::Docs.new(track_id)

        if current_user.fetched?
          erb :"languages/languages", locals: { problems: problems, docs: docs, language: language, slug: track_id }
        else
          erb :"languages/first_problem", locals: { problem: problems.first, docs: docs, language: language, slug: track_id }
        end
      end
    end
  end
end
