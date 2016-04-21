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
        case diff
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
        when less_than(36*hours)
          "about a day ago"
        when less_than(20*days)
          "about #{(diff/(1*days)).round} days ago"
        when less_than(11*weeks)
          "about #{(diff/(1*weeks)).round} weeks ago"
        when less_than(11.5*months)
          "about #{(diff/(1*months)).round} months ago"
        when less_than(18*months)
          "about a year ago"
        else
          "ages ago"
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
