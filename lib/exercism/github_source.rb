class GithubSource
  attr_reader :submission, :tree_source

  def initialize(submission)
    @submission = submission
    @tree_source = Octokit.tree(submission.git_rep_info, submission.commit_id,
                                recursive: true)
  end

  def solution
    (trees + blobs).map { |node|  Node.new(node).get_hash }.to_json
  end

  private

  def blobs
    tree_source.tree.select { |node| node.type == "blob" }
  end

  def trees
    tree_source.tree.select { |node| node.type == "tree" }
  end
end
