module ExercismWeb
  module Routes
    class Comments < Core
      post '/submissions/:key/nitpick' do |key|
        nitpick(key)
        redirect "/submissions/#{key}"
      end

      post '/comments/preview' do
        ConvertsMarkdownToHTML.convert(params[:body])
      end

      get '/submissions/:key/nits/:nit_id/edit' do |key, nit_id|
        please_login("You have to be logged in to do that")
        submission = Submission.find_by_key(key)
        nit = submission.comments.where(id: nit_id).first
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may edit the text."
          redirect "/submissions/#{key}"
        end
        erb :"submissions/edit_nit", locals: {submission: submission, nit: nit}
      end

      post '/submissions/:key/nits/:nit_id' do |key, nit_id|
        nit = Submission.find_by_key(key).comments.where(id: nit_id).first
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may edit the text."
          redirect '/'
        end

        nit.body = params["body"]
        nit.save
        redirect "/submissions/#{key}"
      end

      delete '/submissions/:key/nits/:nit_id' do |key, nit_id|
        submission = Submission.find_by_key(key)
        nit = submission.comments.where(id: nit_id).first
        unless current_user == nit.nitpicker
          flash[:notice] = "Only the author may delete the text."
          redirect '/'
        end

        nit.delete
        submission.nit_count -= 1 unless current_user.owns?(submission)
        submission.save
        redirect "/submissions/#{key}"
      end
    end
  end
end
