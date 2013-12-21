class ExercismApp < Sinatra::Base
  post '/comments/preview' do
    ConvertsMarkdownToHTML.convert(params[:body])
  end
end
