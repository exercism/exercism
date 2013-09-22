class ExercismApp < Sinatra::Base

  def in_curriculum? language
    languages = Exercism.current_curriculum.trails.keys
    languages.include? language.to_sym
  end

  get '/setup/:language/?' do
    language = params[:language].downcase
    unless in_curriculum? language
      status 404
      erb :not_found
    else
      erb :"setup/#{language}"
    end
  end

end
