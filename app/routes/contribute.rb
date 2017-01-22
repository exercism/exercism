module ExercismWeb
  module Routes
    class Contribute < Core
      get '/contribute' do
        erb :"contribute/index"
      end

      get '/contribute/canonical-data/?:slug?' do |slug|
        problem = Trackler.problems[slug]

        erb :"contribute/canonical_data", locals: {
          current_problem: problem,
          problems: Trackler.problems.reject(&:deprecated?).reject(&:canonical_data_url).sort_by(&:name),
          implementations: Trackler.implementations[slug],
        }
      end
    end
  end
end
