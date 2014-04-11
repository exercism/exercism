module ExercismWeb
  module Routes
    class Help < Core
      get '/help/:topic' do |slug|
        topic = slug
        unless article_exists?('help', topic)
          status 404
          topic = '404'
        end

        erb :"help/topic", locals: {topic: topic, substitutions: {'TOPIC' => slug}}
      end

      get '/help/setup/:language' do |language|
        language = ExercismIO::Presenters::Setup.new(language)
        if language.not_found?
          status 404
        end

        erb :"help/topic", locals: {topic: "setup/#{language.topic}", substitutions: {'LANGUAGE' => language.name}}
      end
    end
  end
end
