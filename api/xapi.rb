require 'sinatra/base'
require 'sinatra/petroglyph'
require 'trackler'
require 'exercism'
require 'bugsnag'
require './config/build_id'
require './config/bugsnag'
require 'exercism/homework'
require_relative 'xapi/helpers'

module Xapi
  EXERCISM_URL = "https://github.com/exercism/exercism.io"

  class Restoration
    attr_reader :implementation, :files
    def initialize(implementation:, files:)
      @implementation = implementation
      @files = files
    end

    def self.for(submission)
      track = Trackler.tracks[submission.track_id]
      return unless track.exists?

      implementation = track.implementations[submission.slug]
      return unless implementation.exists?

      files = implementation.files.merge submission.solution

      Restoration.new(implementation: implementation, files: files)
    end
  end

  class App < Sinatra::Base
    configure do
      after { ActiveRecord::Base.connection.close }
    end

    configure do
      set :root, Exercism.relative_to_root('api', 'xapi')
      enable :raise_errors
      use Rack::Session::Cookie,
        key: 'rack.session',
        path: '/',
        expire_after: 2_592_000,
        secret: ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    error Sinatra::NotFound do
      halt 404, { error: "endpoint '#{request.path}' not found." }.to_json
    end

    error 500 do
      Bugsnag.auto_notify($ERROR_INFO, nil, request)
      msg = "So sorry! We've been notified of the error and will investigate."
      { error: msg }.to_json
    end

    helpers ::Xapi::Helpers::Guards
    helpers ::Xapi::Helpers::Finders

    get '/tracks' do
      pg :tracks, locals: {
        tracks: Trackler.tracks,
        todos: Trackler.todos,
      }
    end

    get '/tracks/:id' do |id|
      track = find_track(id)

      pg :track, locals: {
        track: track,
        todos: Trackler.todos,
      }
    end

    # Put 'restore' before /v2/exercise/:track_id
    # otherwise we get 'unknown track restore'.
    get '/v2/exercises/restore' do
      require_key

      exercises = current_user.exercises.order(:language, :slug)
      solutions = exercises.map { |ex| ex.submissions.last }.compact
      restorations = solutions.map { |solution| Restoration.for(solution) }.compact

      pg :restore, locals: { things_to_restore: restorations }
    end

    get '/v2/exercises' do
      require_key

      track_ids = params[:tracks].to_s.split(",").map {|s| s.strip}
      if track_ids.empty?
        track_ids = Trackler.tracks.select(&:active?).map(&:id)
      end
      track_ids = track_ids & Trackler.tracks.map(&:id)

      implementations = track_ids.map do |track_id|
        next_implementation_for(track_id)
      end

      pg :implementations, locals: { implementations: implementations.compact }
    end

    get '/v2/exercises/:track_id' do |track_id|
      require_key

      implementations = [next_implementation_for(track_id)]

      pg :implementations, locals: { implementations: implementations.compact }
    end

    get '/v2/exercises/:track_id/:slug' do |track_id, slug|
      track_id, slug = track_id.downcase, slug.downcase
      _, implementation = find_track_and_implementation(track_id, slug)
      pg :implementations, locals: { implementations: [implementation] }
    end


    private

    def current_user
      user = User.find_by(key: params[:key])
      if user.nil?
        halt 403, {error: "Unknown API key. Check your account on the site for the valid key."}.to_json
      end
      user
    end

    def slugs_by_track_id
      solutions = Homework.new(current_user).all

      hash = Hash.new {|h,k| h[k] = []}
      solutions.each_with_object(hash) do |(track_id, problems), slugs_by_track_id|
      slugs_by_track_id[track_id] = problems.map {|problem|
        problem["slug"]
      }
      end
    end

    def next_implementation_for(track_id)
      track = find_track(track_id)

      slugs = slugs_by_track_id[track_id]
      # pretend they already solved hello-world if they've
      # solved anything at all.
      slugs << 'hello-world' unless slugs.empty?
      next_slug = (track.implementations.map(&:slug) - slugs).first
      return unless next_slug

      implementation = track.implementations[next_slug]
      return unless implementation.exists?

      implementation
    end
  end
end
