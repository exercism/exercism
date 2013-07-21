class ExercismApp < Sinatra::Base

  get '/curriculum' do
    default_trail = Exercism.current_curriculum.trails.keys.first
    redirect "/curriculum/#{ default_trail }"
  end

  get '/curriculum/:id' do |id|
    redirect login_url("/curriculum/#{id}") unless current_user.admin?
    trail = Exercism.current_curriculum.trails[id.to_sym]
    languages = Exercism.current_curriculum.trails.keys
    erb :curriculum, locals: { trail: trail, languages: languages }
  end

end
