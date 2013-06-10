class Assignment

  attr_reader :path, :locale, :slug
  def initialize(locale, slug, path)
    @locale = locale
    @slug = slug
    @path = File.join(path, locale.to_s, slug)
  end

  def language
    locale.language
  end

  def name
    slug.split('-').map(&:capitalize).join(' ')
  end

  def tests
    @tests ||= read(test_file)
  end

  def test_file
    "test.#{locale.test_extension}"
  end

  def example
    @example ||= read(example_file)
  end

  def example_file
    "example.#{locale.code_extension}"
  end

  def blurb
    data['blurb']
  end

  def source
    data['source']
  end

  def source_url
    data['source_url']
  end

  def instructions
    @instructions ||= read('details.md')
  end

  def readme
    @readme ||= <<-README
# #{name}

#{blurb}

#{instructions}

## Source

#{source} [view source](#{source_url})
README
  end

  private

  def data
    @data ||= YAML.load(read('data.yml'))
  end

  def read(file)
    File.read(File.join(path, file))
  end

end
