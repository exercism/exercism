module Sinatra
  module ArticleHelper
    def help_topics
      [
        ['cli', 'Downloading the Command-Line Interface'],
        ['fetch', 'Fetching the Exercises'],
        ['submit', 'Submitting Code'],
        ['nitpick', 'Nitpicking'],
        ['path', 'Understanding PATH'],
        ['troubleshooting', 'Troubleshooting'],
      ] + Exercism.current.map { |language|
        ["setup/#{language.downcase}", "Setting Up #{language}"]
      }
    end

    def article(section, name, substitutions={})
      Article.new(File.read(article_source(section, name)), substitutions)
    end

    def article_exists?(section, name)
      File.exist? article_source(section, name)
    end

    def article_source(section, name)
      File.join(article_dir, section, "#{name.downcase}.md")
    end

    def article_dir
      File.join('lib', 'app', 'articles')
    end
  end
end

