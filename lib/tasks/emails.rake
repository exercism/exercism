namespace :emails do
  desc "reset known invalid values"
  task reset_invalid: [:connection] do

    sql = "UPDATE users SET email=NULL WHERE email=''"
    ActiveRecord::Base.connection.execute(sql)
  end
end
