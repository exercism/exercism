namespace :build do
  task :id do
    require './config/build_id'
    puts BuildID
  end
end

