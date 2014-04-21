require 'sinatra'
require 'sinatra/petroglyph'
require_relative './redesign/helpers/fuzzy_time'
require_relative './legacy/helpers'
require_relative './legacy/alert'

module ExercismLegacy
  class App < Sinatra::Base
    configure do
      set :root, Exercism.relative_to_root('lib', 'legacy')
    end

    configure do
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    before do
      content_type 'application/json', :charset => 'utf-8'
    end

    helpers ExercismLegacy::Helpers::Session
    helpers ExercismIO::Helpers::FuzzyTime

    get '/' do
      require_user
      notifications = current_user.notifications.on_submissions.recent
      alerts = current_user.alerts.map {|alert| ExercismLegacy::Alert.new(alert) }
      pg :notifications, locals: {notifications: alerts + notifications}
    end

    put '/:id' do |id|
      require_user
      if id =~ /alert/
        notification = current_user.alerts.find(id.split('alert-').last)
      else
        notification = current_user.notifications.find(id)
      end

      notification.read!
      pg :notification, locals: {notification: notification}
    end
  end
end
