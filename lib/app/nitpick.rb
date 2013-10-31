class ExercismApp < Sinatra::Base

  post '/preview' do
    ConvertsMarkdownToHTML.convert(params[:body])
  end

  get '/dashboard/:language/?' do |language|
    redirect "/nitpick/#{language}/no-nits"
  end

  get '/dashboard/:language/:slug/?' do |language, slug|
    redirect "/nitpick/#{language}/#{slug}"
  end

  get '/nitpick/:language/?' do |language|
    redirect "/nitpick/#{language}/no-nits"
  end

  get '/nitpick/:language/:slug/?' do |language, slug|
    please_login

    presenter = current_user.sees?(language) ? Workload : NullWorkload
    workload = presenter.new(current_user, language, slug || 'no-nits')

    locals = {
      show_filters: workload.show_filters?,
      submissions: workload.submissions,
      language: workload.language,
      exercise: workload.slug,
      exercises: workload.available_exercises,
      breakdown: workload.breakdown
    }
    erb :nitpick, locals: locals
  end
end

