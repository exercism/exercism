require 'sidekiq'

module Jobs
  class Hello
    include Sidekiq::Worker
    sidekiq_options :queue => :hello

    def perform(submission_uuid)
      # This exists solely to get the job scheduled.
      # There is a stand-alone worker that processes
      # the jobs.
      # See https://github.com/exercism/rikki
    end
  end
end
