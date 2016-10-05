class Watermark < ActiveRecord::Base
  def problem_id
    "%s:%s" % [track_id, slug]
  end
end
