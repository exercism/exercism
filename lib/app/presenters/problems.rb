require 'json'

module ExercismWeb
  module Presenters
    module Special
      class Problem < OpenStruct
      end

      class Problems
        attr_reader :track_id

        def initialize(track_id)
          @track_id = track_id
        end

        def all_problems
          @all_problems ||= fetch_all_problems
        end

        def track_problems
          @track_problems ||= problems_hash
        end

        def fetch_all_problems
          status, body = Xapi.get("problems")
          if status != 200
            raise "something fishy in x-api: (#{status}) - #{body}"
          end
          JSON.parse(body)["problems"]
        end

        def problems_hash
          @track_problems = []
          all_problems.each do |problem|
            slug = problem["slug"]
            if problem["track_ids"].include?(track_id)
              @track_problems << {
                :slug => slug,
                :blurb => problem["blurb"],
                :name => slug.split('-').map(&:capitalize).join(' ')
                }
            end
          end
          @track_problems.map {|problem| Problem.new(problem)}
        end
      end
    end
  end
end
