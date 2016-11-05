require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
end

namespace :test do
  desc "Run each test file independently"
  task :each do
    files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
    failures = files.reject do |file|
      puts "ruby %s" % file
      system("ruby #{file}")
    end

    unless failures.empty?
      puts "FAILURES IN:"
      failures.each do |failure|
        puts failure
      end
      exit 1
    end
  end

  desc 'Run the front-end lineman specs'
  task :lineman do
    exit 1 unless system('cd frontend && npm install && lineman spec-ci')
  end

  desc 'Run the Ruby MiniTest suite'
  task :minitest do
    if ENV['CI'] == '1'
      ENV['COVERAGE'] = '1'
      require 'coveralls/rake/task'
      Coveralls::RakeTask.new
    end

    Rake::Task["test"].invoke
    Rake::Task["coveralls:push"].invoke if ENV['CI'] == '1'
  end

  desc 'Run all tests, linters, and checks'
  task everything: %w(
    test:minitest
    rubocop
    test:lineman
  )
end
