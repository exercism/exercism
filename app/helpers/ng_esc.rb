module ExercismWeb
  module Helpers
    module NgEsc
      def ng_esc(s)
        s.gsub(/['"\\]/, "'" => '\\&apos;', '"' => '\\&quot;', '\\' => '\\&#92;')
      end
    end
  end
end
