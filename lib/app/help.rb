class ExercismApp < Sinatra::Base

  get '/help/how-to-access-exercises' do
    erb :"help/cli"
  end

  get '/help/understanding-path' do
    erb :"help/path"
  end

  get '/help/how-to-nitpick' do
    erb :"help/nitpick"
  end

  get '/help/nitpick/ruby/bob' do
    erb :blog, locals: {markdown: File.read('./lib/nitpick/ruby/bob.md')}
  end

  get '/help/setup/:language/?' do
    language = params[:language].downcase.to_sym
    if Exercism.languages.include?(language)
      erb :"setup/#{language}"
    else
      status 404
      erb :not_found
    end
  end
end
