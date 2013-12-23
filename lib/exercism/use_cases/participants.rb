require 'set'

class Participants
  def self.in(submissions)
    users = Set.new
    submissions.each do |submission|
      users.add submission.user
      submission.comments.each do |comment|
        users.add comment.user
        users.merge comment.mentions
      end
    end
    users
  end
end
