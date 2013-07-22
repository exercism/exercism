class ExercismApp < Sinatra::Base

  helpers do
    def progress(language)
      map = %q{
        function() {
          var nits = this.nits || [],
              summary = { nits: nits.length, pending: 0, superseded: 0, approved: 0 },
              state = this.state;
          if (typeof(state) === 'undefined') { state = 'pending'; }
          summary[state] = 1;
          emit(this.s, summary);
        }
      }

      reduce = %q{
        function(key, values) {
          var result = { nits: 0, pending: 0, superseded: 0, approved: 0 };

          values.forEach(function(value) {
            result.nits       += value.nits;
            result.pending    += value.pending;
            result.superseded += value.superseded;
            result.approved   += value.approved;
          });

          return result;
        }
      }

      Submission.where(l: language).map_reduce(map, reduce).out(inline: true).each_with_object({}) do |exercise, summary|
        summary[exercise['_id']] = exercise['value']
      end
    end

    def quantify(value)
      q = value.to_i
      q > 0 ? q : nil
    end
  end

  get '/curriculum' do
    default_trail = Exercism.current_curriculum.trails.keys.first
    redirect "/curriculum/#{ default_trail }"
  end

  get '/curriculum/:id' do |id|
    redirect login_url("/curriculum/#{id}") unless current_user.admin?
    trail = Exercism.current_curriculum.trails[id.to_sym]
    languages = Exercism.current_curriculum.trails.keys
    progress = progress(id)

    erb :curriculum, locals: { trail: trail, languages: languages, progress: progress }
  end

end
