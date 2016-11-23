module ExercismWeb
  module Helpers
    # Returns the url for the current version of the application.css file
    module CssUrl
      def css_url
        @css_url ||= url_for_resource('/css/application.css')
      end

      private

      def url_for_resource(resource)
        fail IOError.new not_found_message(resource) unless exist?(resource)
        "#{resource}?t=#{timestamp(resource)}"
      end

      def not_found_message(resource)
        css_filename = filename(resource)
        command = "bundle exec compass compile"
        url = 'https://github.com/exercism/exercism.io/blob/master/CONTRIBUTING.md#scss'

        <<-MESSAGE.gsub(/^ */, '')
            '#{css_filename}' not found.
            Try running '#{command}' to generate it.
            For more information: #{url}
            MESSAGE
      end

      def exist?(resource)
        File.exist?(filename(resource))
      end

      def filename(resource)
        File.join(settings.public_folder, resource)
      end

      def timestamp(resource)
        File.mtime(filename(resource)).to_i
      end
    end
  end
end
