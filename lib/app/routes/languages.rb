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
          exists = true
        rescue => e
          Bugsnag.notify(e, nil, request)
          exists = false
        end

        return erb :"languages/in_progress", locals: { language: Language.of(track_id), slug: track_id } if exists && !active

        locals = {
          problems: Presenters::Special::Problems.new(track_id).track_problems,
          docs: Presenters::Docs.new(track_id),
          language: Language.of(track_id),
          slug: track_id,
          active: active,
        }
        erb :"languages/languages", locals: locals
      end
    end
  end
end
