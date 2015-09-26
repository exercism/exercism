module AppPresentersHelper
  def all_problems_json
    problems_file = File.expand_path('../fixtures/approvals/api_all_problems.approved.json', __FILE__)
    File.read(problems_file)
  end

  def ruby_track_problems_array
    array_file = File.expand_path('../fixtures/approvals/ruby_track_problems.approved.txt', __FILE__)
    File.read(array_file)
  end
end
