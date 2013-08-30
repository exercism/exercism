class ExercismApp < Sinatra::Base

  get '/help/how-to-access-exercises' do
    erb :"help/cli"
  end

  get '/help/how-to-nitpick' do
    erb :"help/nitpick"
  end

  get '/nitpick/ruby/bob' do
    erb :blog, locals: {markdown: File.read('./lib/nitpick/ruby/bob.md')}
  end

end
