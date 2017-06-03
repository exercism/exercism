module ExercismWeb
  module Routes
    class Contribute < Core
      get '/contribute' do
        erb :"contribute/index"
      end

      get '/contribute/canonical-data/?:slug?' do |slug|
        slug ||= ''

        active_problems = Trackler.specifications.reject(&:deprecated?).sort_by(&:name)
        need_canonical  = active_problems.reject(&:canonical_data_url)

        erb :"contribute/canonical_data", locals: {
          current_problem: Trackler.specifications[slug],
          implementations: Trackler.implementations[slug],
          problems: need_canonical,
          active_problems_count: active_problems.size,
          canonical_problems_count: [active_problems - need_canonical].size
        }
      end
    end
  end
end
