namespace :rikki do
  desc "analyze ruby hamming"
  task :analyze do
    require './lib/exercism'
    require './lib/jobs/analyze'

    queue = Proc.new {|submission| Jobs::Analyze.perform_async(submission.key)}
    Submission.where(language: 'ruby', slug: 'hamming', nit_count: 0).where('created_at > ?', Time.now-6.weeks).where("state='pending' OR state='needs-input'").find_each.map(&queue); nil
  end
end
