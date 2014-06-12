module Explore
  class Conversation
    def self.load(path)
      JSON.parse(File.read(path)).map do |iteration|
        code = iteration['code']
        language = iteration['language']
        comments = iteration['comments'].map {|comment| Comment.new(comment)}
        Iteration.new(code, language, comments)
      end
    end
  end

  class Comment
    attr_reader :username, :avatar, :text

    def initialize(data)
      @username = data["username"]
      @author = data["author"]
      @avatar = data["avatar"]
      @text = data["text"]
    end

    def author?
      @author
    end
  end

  class Iteration
    attr_reader :code, :language, :comments
    def initialize(code, language, comments)
      @code, @language, @comments = code, language, comments
    end
  end
end
