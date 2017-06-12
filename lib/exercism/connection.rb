module Connection
  def self.included(base)
    base.extend(Method)
    base.send(:include, Method)
  end

  module Method
    def connect_to(url)
      Faraday.new(url: url) do |c|
        c.use Faraday::Response::Logger
        c.use Faraday::Adapter::NetHttp
      end
    end
  end
end
