require 'open-uri'

module ExercismWeb
    module Helpers
        module URIHelper
            def encode_uri(str)
                URI::encode(str)
              end
          end
      end
  end
