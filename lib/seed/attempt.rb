module Seed
  Attempt = Struct.new(:language, :slug, :created_at, :state) do
    def attributes
      members.each_with_object({}) do |member, attrs|
        attrs[member] = send(member)
      end.merge(code: 'CODE')
    end

    def completed?
      state == 'done'
    end

    def by(user)
      attributes.merge(user: user)
    end

    def comments
      @comments ||= generate_comments
    end

    private

    def generate_comments
      timestamp = nil
      comments = []
      rand(1..5).times do
        timestamp = after(timestamp)
        comments << Seed::Comment.new(Faker::Company.bs, timestamp)
      end
      comments
    end

    def after(timestamp)
      (timestamp || created_at) + rand(1000..100000)
    end
  end
end
