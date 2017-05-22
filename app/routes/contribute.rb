module ExercismWeb
  module Routes
    class Contribute < Core
      get '/contribute' do
        erb :"contribute/index"
      end

      get '/contribute/canonical-data/?:slug?' do |slug|
        slug ||= ''
        problem = Trackler.problems[slug]

        erb :"contribute/canonical_data", locals: {
          current_problem: problem,
          problems: Trackler.problems.reject(&:deprecated?).reject(&:canonical_data_url).sort_by(&:name),
          active_problems_count: Trackler.problems.reject(&:deprecated?).size,
          canonical_problems_count: Trackler.problems.select(&:canonical_data_url).size,
          implementations: Trackler.implementations[slug],
        }
      end
    end
  end
end
