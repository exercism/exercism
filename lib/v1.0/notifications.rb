class ExercismV1p0 < Sinatra::Base
  delete '/notifications/read' do
    please_login

    NotificationCenter.new(current_user).gc

    redirect back
  end

  delete '/notifications/:id' do |id|
    please_login

    NotificationCenter.new(current_user).delete(id)

    redirect back
  end
end
