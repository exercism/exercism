namespace :looks do
  desc "clear out old pageviews"
  task :gc do
    require 'bundler'
    Bundler.require
    require 'exercism'

    sql = "DELETE FROM looks WHERE updated_at < '#{Date.today-30}'"
    Look.connection.execute(sql)
  end
end
