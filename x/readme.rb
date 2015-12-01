module X
  module Exercise
    class Readme
      def self.find(track, slug)
         _, body = X::Xapi.get('tracks', 'track', 'exercises', slug, 'readme')
         new(JSON.parse(body)['exercise'])
      end

      METHODS = [
        :readme, :track, :id
      ]
      
      attr_reader(*METHODS)
      
      def initialize(data)
        METHODS.each do |name|
          instance_variable_set(:"@#{name}", data[name.to_s])
        end
      end
    end
  end
end
