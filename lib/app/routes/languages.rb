require 'app/presenters/problems'

module ExercismWeb
  module Routes
    class Languages < Core
      get '/languages' do
        erb :"languages/all"
      end

      get '/languages/:track_id' do |track_id|
        begin
          active = ExercismWeb::Presenters::Tracks.find(track_id.to_s).active?
        rescue => e
          Bugsnag.notify(e, nil, request)
          return erb:"languages/not_implemented", locals: { language: Language.of(track_id) }
        end

        return erb :"languages/in_progress", locals: { language: Language.of(track_id), slug: track_id } if !active

        locals = {
          problems: Presenters::Special::Problems.new(track_id).track_problems,
          docs: Presenters::Docs.new(track_id),
          language: Language.of(track_id),
          slug: track_id,
        }
        erb :"languages/languages", locals: locals
      end
    end
  end
end
