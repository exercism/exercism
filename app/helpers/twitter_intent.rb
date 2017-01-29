module ExercismWeb
  module Helpers
    module TwitterIntent

      def twitter_share_from_submission(submission)
        text =
          'I just submitted the #%s %s exercise at @exercism_io '\
          '- Leave me a nitpick at ' \
          % [submission.problem.language, submission.slug]
        url = 'http://exercism.io/submissions/%s' % [submission.key]
        twitter_share(text: text, url: url)
      end

      def twitter_share(opts = {})
        "#{TWITTER_URL}%s" % opts.slice(*TWITTER_KEYS).to_query
      end

      private

      TWITTER_URL = 'https://twitter.com/intent/tweet?'.freeze
      TWITTER_KEYS = %i(text url).freeze

      private_constant :TWITTER_URL, :TWITTER_KEYS
    end
  end
end
