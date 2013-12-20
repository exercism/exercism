class ExercismApp < Sinatra::Base

  helpers do
    def progress(language)
      summary = Hash.new {|hash, key| hash[key] = {}}
      Submission.select('slug, state, count(id)').where(language: 'ruby').group(:slug, :state).each do |submission|
        summary[submission.slug][submission.state] = submission.count.to_i
      end
      sql = "SELECT s.slug, COUNT(c.id) nits FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE s.language=? GROUP BY slug"
      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, language])

      ActiveRecord::Base.connection.execute(query).to_a.each do |submission|
        summary[submission["slug"]]["nits"] = submission["nits"]
      end
      summary
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
    please_login

    unless current_user.locksmith?
      flash[:notice] = "Sorry, need to know only."
      redirect '/'
    end

    trail = Exercism.current_curriculum.trails[id.to_sym]
    languages = Exercism.current_curriculum.trails.map {|_, t| t.name}
    progress = progress(id)

    erb :curriculum, locals: { trail: trail, languages: languages, progress: progress }
  end

end
