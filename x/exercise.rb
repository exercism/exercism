module X
  module Exercise
    def self.exists?(language, slug)
      Xapi.request('tracks', language, slug).status != 404
    end
  end
end
