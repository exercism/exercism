module Api
  module Stats
    class Nitpicks
      attr_reader :languages, :data, :year, :month
      def initialize(languages, data, year, month)
        @languages = languages.map(&:to_s)
        @data = data
        @year = year
        @month = month
      end

      def by_language_and_date
        @by_language_and_date ||= group_by_language_and_date
      end

      def to_h
        result = Hash.new {|hash, language| hash[language] = []}
        languages.each do |language|
          (start_date..end_date).each do |date|
            result[language] << counts_for(date, language)
          end
        end
        result
      end

      private

      def counts_for(date, language)
        date = date.strftime('%Y-%m-%d')
        {'date' => date, 'nit_count' => by_language_and_date[language][date]}
      end

      def start_date
        @start_date ||= Date.new(year, month, 1)
      end

      def end_date
        @end_date ||= Date.new(year, month, -1)
      end

      def group_by_language_and_date
        result = Hash.new {|hash, language| hash[language] = Hash.new(0)}
        data.group_by {|row| row["language"]}.each do |language, rows|
          rows.each do |row|
            result[language][row["date"]] = row["nit_count"].to_i
          end
        end
        result
      end
    end
  end
end
