require 'app/help/setup'

class ExercismApp < Sinatra::Base
  get '/help' do
    erb :"help/topic", locals: {topic: 'index', substitutions: {}}
  end

  get '/help/:topic' do |slug|
    topic = slug
    unless article_exists?('help', topic)
      status 404
      topic = '404'
    end

    erb :"help/topic", locals: {topic: topic, substitutions: {'TOPIC' => slug}}
  end

  get '/help/setup/:language' do |language|
    language = App::Help::Setup.new(language)
    if language.not_found?
      status 404
    end

    erb :"help/topic", locals: {topic: "setup/#{language.topic}", substitutions: {'LANGUAGE' => language.name}}
  end
end
