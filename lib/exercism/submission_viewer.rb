class SubmissionViewer < ActiveRecord::Base

  belongs_to :submission
  belongs_to :viewer, class_name: "User"

  validates :viewer_id, uniqueness: {scope: :submission_id}

end
