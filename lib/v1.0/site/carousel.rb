module App
  module Site
    class Carousel
      class Nitpicker < Struct.new(:username, :comment); end

      def self.slides(path)
        @slides ||= nitpicks.map.with_index do |nitpick, i|
          Carousel.new(i+1, Nitpicker.new(*nitpick), path)
        end
      end

      def self.nitpicks
        [
          ["niquot", "Have you looked at the Enumerable module? It has some great methods that can help reduce the boilerplate."],
          ['guice', "When I have a collection that I'm looping over I like to name the collection as the plural of what it contains, and the block variable as the singular. What are we actually looping over here?"],
          ['guice', "I'm not sure what 4 means, on line 3."],
          ['mirandaX', "Is there a way that you could ask the cell itself a question rather than getting data out of it and doing a comparison?"],
          ['niquot', "The method name doesn't tell the reader very much about what we're actually getting back. `them` seems pretty unspecific, and the fact that we're _getting_ `them` is kind of irrelevant. What if this were just named for what it represents?"],
          ['mirandaX', "This is so much easier to understand. I like it!"]
        ]
      end

      attr_reader :i, :nitpicker, :path
      def initialize(i, nitpicker, path)
        @i = i
        @nitpicker = nitpicker
        @path = path
      end

      def iteration
        "%02d" % i
      end

      def first?
        i == 1
      end

      def hours
        20 - i
      end

      def code
        ConvertsMarkdownToHTML.convert("```ruby\n#{code_sample}\n```")
      end

      def username
        nitpicker.username
      end

      def comment
        ConvertsMarkdownToHTML.convert(nitpicker.comment)
      end

      private

      def code_sample
        File.read(File.join(path, "i#{i}.rb"))
      end
    end
  end
end
