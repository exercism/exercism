class ExercismV1p0 < Sinatra::Base
  delete '/alerts/:id' do |id|
    please_login

    current_user.alerts.find(id).destroy

    redirect back
  end
end
