class Notification < ActiveRecord::Base
  scope :relevant_to, lambda {|exercise| unread.on_submissions.where(item_id: exercise.submissions.map(&:id)) }
end

module Hack
  module Notifications
    class Sync
      attr_reader :exercise
      def initialize(exercise)
        @exercise = exercise
      end

      def process
        each_subject do |(regarding, user_id), nx|
          data = {
            user_id: user_id,
            regarding: regarding,
            item_id: exercise.id,
            item_type: 'UserExercise',
          }
          created_at = nx.map(&:created_at).sort.first
          notification = Notification.unread.where(data).first || Notification.new(data.merge(created_at: created_at))
          notification.count = nx.inject(0) {|sum, n| sum + n.count}
          notification.updated_at = nx.map(&:updated_at).sort.last
          notification.save
        end
      end

      private

      def each_subject
        Notification.relevant_to(exercise).group_by {|n| [n.regarding, n.user_id]}.each do |data|
          yield data
        end
      end
    end
  end
end
