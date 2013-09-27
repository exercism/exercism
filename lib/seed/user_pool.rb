module Seed
  Person = Struct.new(:id, :name)

  class UserPool
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def ids
      @ids ||= (1..size).to_a.map {|i| i * -1}
    end

    def names
      @names ||= generate_names
    end

    def people
      @people ||= ids.zip(names).map do |id, name|
        Person.new(id, name)
      end
    end

    private

    def generate_names
      names = []
      size.times do
        name = Faker::Name.first_name.downcase
        while names.include? name
          name = name + rand(0..9).to_s
        end
        names << name
      end
      names
    end
  end
end
