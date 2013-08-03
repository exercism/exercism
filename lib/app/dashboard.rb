require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

  get '/dashboard/:language' do |language|
    if current_user.guest?
      erb :index
    else
      dashboard = Dashboard.new(current_user, Submission.filter(submissions_params(language)))

      locals = {
        submissions: dashboard.submissions,
        filters: dashboard.filters
      }
      erb :dashboard, locals: locals
    end
  end

  def submissions_params(language)
    {
      language: language,
      date: date,
    }
  end

  def date
    return Date.today unless params[:date]
    begin
      Date.parse(params[:date])
    rescue ArgumentError
      Date.today
    end
  end
end
