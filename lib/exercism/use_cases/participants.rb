require 'set'

class Participants
  def self.in(submissions, current_id)
    users = Set.new
    submissions.each do |submission|
      users.add submission.user
      submission.comments.each do |comment|
        users.add comment.user
      end
      if submission.id == current_id
        submission.comments.each do |comment|
          users.merge comment.mentions
        end
      end
    end
    users
  end
end
