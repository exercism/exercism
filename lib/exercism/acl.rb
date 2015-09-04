class ACL < ActiveRecord::Base
  def self.authorize(user, problem)
    ACL.create(user_id: user.id, language: problem.track_id, slug: problem.slug)
  rescue ActiveRecord::RecordNotUnique
    ACL.where(user_id: user.id, language: problem.track_id, slug: problem.slug).update_all(updated_at: Time.now.utc)
  end
end
