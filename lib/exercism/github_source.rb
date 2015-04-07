class GithubSource
  attr_reader :user, :slug, :code, :submission

  def initialize(submission)
    @submission = submission
    @user = submission.user
    @slug = submission.slug
    @code = submission.code
  end

  def solution
    Octokit.configure do |c|
      c.login = "SaiPramati"
      c.password = "pramati123"
    end
    result = []

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
      node_contents[:icon] = node.type.eql?("tree") ? "" : "file"
      node_contents[:data] = { sha: node.sha, type: node_contents[:icon] }
      result << node_contents
    end
    result.to_json
  end
  private
    def sorted_blobs
      git_tree_source.tree.select{ |node| node.type == "blob" }
    end

    def sorted_trees
      git_tree_source.tree.select{ |node| node.type == "tree" }
    end

    def git_tree_source
      repo_info = "#{submission.user.username}/#{submission.slug}"
      commit_id = submission.solution.values.first
      @git_tree_source ||= Octokit.tree(repo_info, commit_id, recursive: true)
    end
end
