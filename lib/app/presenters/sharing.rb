class Sharing
  def twitter_link(submission)
    %{<a href="https://twitter.com/intent/tweet?text=I just submitted the #{submission.track_id} #{submission.slug} exercise at @exercism_io - Leave me a nitpick at http://exercism.io/submissions/#{submission.key}" id='twitter-share'>Share with Twitter</a>}
  end
end
