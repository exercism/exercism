require 'sidekiq'

module Jobs
  class Analyze
    include Sidekiq::Worker
    sidekiq_options :queue => :analyze

    def perform(_)
      # This exists solely to get the job scheduled.
      # There is a stand-alone worker that processes
      # the jobs.
      # See https://github.com/exercism/rikki
    end
  end
end
