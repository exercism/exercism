module Xapi
  module Helpers
    module Guards
      def require_key
        params.fetch(:key) {
          halt 401, { error: "Please provide your Exercism.io API key" }.to_json
        }
      end
    end
  end
end
