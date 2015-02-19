class GithubSource
  attr_reader :github, :user, :slug, :code

  def initialize(submission)
    @github = Github.new
    @user = submission.user
    @slug = submission.slug
    @code = submission.code
  end

  def solution
    trees = github.git_data.trees.get user.username, slug, code
    src_url = trees.tree.last.url

    res = {}
    trees.tree.each do |tree_item|
      uri = URI(tree_item.url)
      resp = JSON.parse(Net::HTTP.get(uri))
      res[tree_item.path] = Base64.decode64(resp["content"])
    end

    res
  end
end
