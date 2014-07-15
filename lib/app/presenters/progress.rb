module ExercismWeb
  module Presenters
    class Metric
      attr_accessor :pending, :superseded, :hibernating, :done, :needs_input, :nits

      attr_reader :slug
      def initialize(slug)
        @slug = slug
      end
    end

    class Progress
      attr_reader :language
      def initialize(language)
        @language = language
      end

      def metrics
        @metrics ||= summarize
      end

      private

      def summarize
        data = by_status
        nit_counts.each do |record|
          data[record["slug"]].nits = record["nits"].to_i
        end
        data.values
      end

      def by_status
        summary = Hash.new {|hash, key| hash[key] = Metric.new(key)}
        Submission.select('slug, state, count(id)').where(language: language).group(:slug, :state).each do |submission|
          summary[submission.slug].send("#{submission.state}=", submission.count.to_i)
        end
        summary
      end

      def nit_counts
        sql = "SELECT s.slug, COUNT(c.id) nits FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE s.language=? GROUP BY slug"
        query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, language])
        Submission.connection.execute(query)
      end

    end
  end
end
