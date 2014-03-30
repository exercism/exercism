module ExercismIO
  module Helpers
    module Article
      def namify(slug)
        slug.to_s.split('-').map(&:capitalize).join('-')
      end

      def help_topics
        [
          ['cli', 'Downloading the Command-Line Interface'],
          ['fetch', 'Fetching the Exercises'],
          ['submit', 'Submitting Code'],
          ['nitpick', 'Nitpicking'],
          ['path', 'Understanding PATH'],
          ['troubleshooting', 'Troubleshooting'],
        ] + Exercism::Config.languages.map { |language|
          ["setup/#{language}", "Setting Up #{namify(language)}"]
        }
      end

      def article(section, name, substitutions={})
        ::Article.new(File.read(article_source(section, name)), substitutions)
      end

      def article_exists?(section, name)
        File.exist? article_source(section, name)
      end

      def article_source(section, name)
        File.join(article_dir, section, "#{name.downcase}.md")
      end

      def article_dir
        File.join('lib', 'redesign', 'articles')
      end
    end
  end
end
