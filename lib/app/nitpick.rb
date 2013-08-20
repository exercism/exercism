class ExercismApp < Sinatra::Base

  get '/nitpick' do
    erb :"about/nitpick"
  end

  get '/nitpick/ruby/bob' do
    erb :blog, locals: {markdown: File.read('./lib/nitpick/ruby/bob.md')}
  end

  post '/preview' do
    md(params[:comment])
  end

end
