require 'sourceclassifier'
module ExercismWeb
  module Routes
    class Exercises < Core
      get '/nitpick/:language/:slug/?' do |track_id, slug|
        please_login

        workload = Workload.new(current_user, track_id, slug || 'recent')

        locals = {
          submissions: workload.submissions,
          language: workload.track_id,
          exercise: workload.slug,
          exercises: workload.available_exercises,
          breakdown: workload.breakdown
        }
        erb :"nitpick/index", locals: locals
      end

      get '/submissions/:key' do |key|
        submission = Submission.includes(:user, comments: :user).find_by_key(key)
        unless submission
          flash[:error] = "We can't find that submission."
          redirect '/'
        end

        if current_user.guest?
          workload = NullWorkload.new
        else
          submission.viewed!(current_user)
          Look.check!(submission.user_exercise_id, current_user.id)
          Notification.viewed!(submission, current_user)
          workload = Workload.new(current_user, submission.track_id, submission.slug)
        end
        next_submission = workload.next_submission(submission)

        title("%s by %s in %s" % [submission.problem.name, submission.user.username, submission.problem.language])
        src_klass = submission.user.source_klass
        src_obj = src_klass.new(submission)
        if src_klass == GithubSource
          data = {submission: submission,
                  next_submission: next_submission,
                  sharing: Sharing.new,
                  solution: get_tree(submission)}
        else
          data = {
            submission: submission,
            next_submission: next_submission,
            sharing: Sharing.new,
            solution: src_obj.solution,
          }
        end
        erb :"submissions/show", locals: data
      end

      post '/submissions/:key/like' do |key|
        please_login "You have to be logged in to do that."
        submission = Submission.find_by_key(key)
        if submission.nil?
          flash[:notice] = "No such exercise found"
          redirect "/"
        end

        submission.like!(current_user)
        Notify.source(submission, 'like', current_user)
        redirect "/submissions/#{key}"
      end

      # Provide unlike, mute, and unmute actions.
      {
        "unlike" => "The submission has been unliked.",
        "mute" => "The submission has been muted. It will reappear when there has been some activity.",
        "unmute" => "The submission has been unmuted."
      }.each do |action, confirmation|
        post "/submissions/:key/#{action}" do |key|
          please_login "You have to be logged in to do that."
          submission = Submission.find_by_key(key)
          submission.send("#{action}!", current_user)
          flash[:notice] = confirmation
          redirect "/submissions/#{key}"
        end
      end

      get %r{/submissions/(?<key>\w+)/(nitpick$|(\+?un)?like$|(\+?un)?mute$)} do |key|
        redirect "/submissions/#{key}"
      end

      post '/submissions/:key/done' do |key|
        please_login("You have to be logged in to do that")
        submission = Submission.find_by_key(key)
        unless current_user.owns?(submission)
          flash[:notice] = "Only the submitter may complete the exercise."
          redirect "/submissions/#{key}"
        end
        Completion.new(submission).save
        LifecycleEvent.track('completed', current_user.id)
        flash[:success] = "#{submission.name} in #{submission.track_id} will no longer appear in the nitpick lists."
        redirect "/"
      end

      post '/submissions/:key/reopen' do |key|
        please_login
        selected_submission = Submission.find_by_key(key)
        unless current_user.owns?(selected_submission)
          flash[:notice] = "Only the current submitter may reopen the exercise"
          redirect '/'
        end

        submission = Submission.where(user_id: current_user.id, language: selected_submission.track_id, slug: selected_submission.slug, state: 'done').first
        if submission.nil?
          flash[:notice] = "No such submission"
          redirect "/"
        end

        submission.state = 'pending'
        submission.done_at = nil
        submission.save
        Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
        redirect "/submissions/#{submission.key}"
      end

      delete '/submissions/:key' do |key|
        please_login
        submission = Submission.find_by_key(key)
        if submission.nil?
          redirect '/'
        end

        unless current_user.owns?(submission)
          flash[:notice] = "Only the current submitter may delete the exercise."
          redirect '/'
        end

        decrement_version(submission)
        prior = submission.prior
        if prior && (submission.state == 'pending')
          prior.state = 'pending'
          prior.save
        end
        submission.destroy
        Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
        redirect "/"
      end

      get '/submissions/blob/content' do
        content_type :json
        submission = Submission.find_by_key(params[:key])
        blob = Octokit.blob("#{submission.user.username}/#{submission.slug}", params[:sha])
        #blob = Octokit.blob("hanumakanthvvn/exercism.io", params[:sha])
        s = SourceClassifier.new(File.join(File.dirname(__FILE__), '../../../bin/', 'trainer.bin'))
        result =  Base64.decode64(blob.content)
        source_language = s.identify(result)
        marked_content = ConvertsMarkdownToHTML.convert("```#{source_language.downcase}\n#{result}\n```")
        content = { data: marked_content } 
        content.to_json
      end

      def get_tree(submission)
        Octokit.configure do |c|
          c.login = 'SaiPramati'
          c.password = 'pramati123'
        end
        git_tree_source = Octokit.tree("#{submission.user.username}/#{submission.slug}",
                                        submission.solution.values.first, recursive: true)
        # git_tree_source = Octokit.tree("hanumakanthvvn/exercism.io",
        #                                 "5def0c8bffba83662c7bcf9c5f6eb249f52a0a26", recursive: true)

        result = []
        sorted_blobs = git_tree_source.tree.select{|node| node.type == 'blob'}
        sorted_trees = git_tree_source.tree.select{|node| node.type == 'tree'}

        (sorted_trees + sorted_blobs).each do |node|
          node_contents = {}
          node_contents[:id] = node.path
          git_path_names = node.path.split("/")
          node_contents[:text] = git_path_names.last
          if git_path_names.size == 1
            parent = "#"
          else
            git_path_names.pop
            parent = git_path_names.join("/")
          end
          node_contents[:parent] = parent
          node_contents[:icon] = node.type.eql?('tree') ? '' : 'file'
          node_contents[:data] = { sha: node.sha, type: node_contents[:icon] }
          result << node_contents
        end
        result.to_json
      end
    end
  end
end
