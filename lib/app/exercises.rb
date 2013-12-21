class ExercismApp < Sinatra::Base
  get '/exercises/:slug' do |slug|
    erb :"exercises/readme", locals: {readme: Readme.new(slug).text}
  end
end
