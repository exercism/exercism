module ExercismWeb
  module Helpers
    module NgEsc
      def ng_esc(s)
        s.gsub(/['"\\]/, {%q{'} => %q{\\&apos;}, %q{"} => %q{\\&quot;}, '\\' => %q{\\&#92;}})
      end
    end
  end
end
