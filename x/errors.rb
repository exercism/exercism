module X
  class LanguageNotFound < StandardError
    attr_reader :code, :body, :track_id
    def initialize(code:, body:, track_id:)
      @code = code
      @body = body
      @track_id = track_id
    end
  end
end
