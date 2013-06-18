# Requiring ActionView::Helpers::DateHelper
# pulled in all sorts of unnecessary code,
# including all of nokogiri and, apparently, bson_ext.
# Hand-rolling.
module Sinatra
  module FuzzyTimeHelper

    def ago(timestamp)
      diff = (now - timestamp).to_i
      case
      when just_now?(diff) then "just now"
      when minutes?(diff) then "about #{diff/60} minutes ago"
      when an_hour?(diff) then "about an hour ago"
      when an_hour_and_a_half?(diff) then "about an hour and a half ago"
      when hours?(diff) then "about #{(diff/(60*60.0)).round} hours ago"
      when a_day?(diff) then "about a day ago"
      when days?(diff) then "about #{(diff/(24*60*60.0)).round} days ago"
      when weeks?(diff) then "about #{(diff/(7*24*60*60.0)).round} weeks ago"
      when months?(diff) then "about #{(diff/(30*24*60*60.0)).round} months ago"
      when a_year?(diff) then "about a year ago"
      else
        "ages ago"
      end
    end

    private

    def now
      Time.now.utc
    end

    def just_now?(diff)
      diff < 120
    end

    def minutes?(diff)
      diff < 55*60
    end

    def an_hour?(diff)
      diff < 80*60
    end

    def an_hour_and_a_half?(diff)
      diff < 105*60
    end

    def hours?(diff)
      diff < ((23*60*60) + (30*60))
    end

    def a_day?(diff)
      diff <= (36*60*60)
    end

    def days?(diff)
      diff < (20*24*60*60)
    end

    def weeks?(diff)
      diff < (11*7*24*60*60)
    end

    def months?(diff)
      diff <= (11*30*24*60*60) + (14*24*60*60)
    end

    def a_year?(diff)
      diff < (18*30*24*60*60)
    end

  end
end

