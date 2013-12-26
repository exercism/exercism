module Sinatra
  module ArticleHelper
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

