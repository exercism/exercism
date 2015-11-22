module ExercismWeb
  module Presenters
    class Metric
      attr_accessor :active, :archived, :comments

      attr_reader :slug
      def initialize(slug)
        @slug = slug
      end
    end

    class Progress
      attr_reader :track_id, :language
      def initialize(track_id, language)
        @track_id = track_id
        @language = language
      end

      def metrics
        @metrics ||= summarize
      end

      private

      def summarize
        data = by_status
        nit_counts.each do |record|
          data[record["slug"]].comments = record["nits"].to_i
        end

        new_data = {}
        language_track = LanguageTrack.new(track_id)
        language_track.ordered_exercises.each do |exercise|
          next if data[exercise].nil?
          new_data[exercise] = data[exercise]
        end

        new_data.values
      end

      def by_status
        summary = {}
        UserExercise.select('slug, archived, count(id)').where(language: track_id).group(:slug, :archived).each do |exercise|
          summary[exercise.slug] ||= Metric.new(exercise.slug)

          if exercise.archived
            summary[exercise.slug].archived = exercise.count.to_i
          else
            summary[exercise.slug].active = exercise.count.to_i
          end
        end
        summary
      end

      def nit_counts
        sql = "SELECT s.slug, COUNT(c.id) nits FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE s.language=? GROUP BY slug"
        query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, track_id])
        Submission.connection.execute(query)
      end

    end
  end
end
