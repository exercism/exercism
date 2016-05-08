# Requiring ActionView::Helpers::DateHelper
# pulled in all sorts of unnecessary code,
# including all of nokogiri and, apparently, bson_ext.
# Hand-rolling.
module ExercismWeb
  module Helpers
    module FuzzyTime
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def ago(timestamp)
        diff = (now - timestamp).to_i.to_f
        if diff < 24*hours
          response = case diff
          when less_than(2*minutes)
            "just now"
          when less_than(55*minutes)
            "about #{(diff/(1*minutes)).round} minutes ago"
          when less_than(80*minutes)
            "about an hour ago"
          when less_than(105*minutes)
            "about an hour and a half ago"
          when less_than(23.5*hours)
            "about #{(diff/(1*hours)).round} hours ago"
          end
          "<a href='#' data-toggle='tooltip' title='#{timestamp.strftime("%e %B %Y at %H:%M %Z")}'>#{response}</a>"
        else
          timestamp.strftime("%e %B %Y at %H:%M %Z")
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity

      private

      def less_than timespan
        ->(actual_timespan) { actual_timespan < timespan }
      end

      def now
        Time.now.utc
      end

      def minutes
        60
      end

      def hours
        60*minutes
      end

      def days
        24*hours
      end

      def weeks
        7*days
      end

      def months
        30*days
      end
    end
  end
end
