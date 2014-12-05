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

        language_tracks = JSON.parse Xapi.get("tracks")[1]
        ordered_problems = language_tracks["tracks"].select{|x| x['slug'] == language}[0]["problems"]
        ordered_problems.map! {|x| x.split("#{language}/")[1]}

        new_data = {}
        ordered_problems.each do |exercise|
          next if data[exercise].nil?
          new_data[exercise] = data[exercise]
        end

        new_data.values
      end

      def by_status
        summary = {}
        Submission.where("state != 'deleted'").select('slug, state, count(id)').where(language: language).group(:slug, :state).each do |submission|
          summary[submission.slug] ||= Metric.new(submission.slug)
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
