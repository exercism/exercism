class Assignment

  attr_reader :path, :locale, :slug, :data_dir
  def initialize(locale, slug, path)
    @locale = locale
    @slug = slug
    @data_dir = path
    @path = File.join(path, locale.to_s, slug)
  end

  def language
    locale.language
  end

  def name
    exercise.name
  end

  def exercise
    @exercise ||= Exercise.new(language, slug)
  end

  def tests
    @tests ||= read(test_file)
  end

  def test_file
    "#{slug}_test.#{locale.test_extension}"
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
    @instructions ||= read_shared("#{slug}.md")
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
    @data ||= YAML.load(data_file)
  end

  def data_file
    read_shared("#{slug}.yml")
  end

  def read_shared(file)
    File.read(File.join(data_dir, 'shared', file))
  end

  def read(file)
    File.read path_to(file)
  end

  def path_to(file)
    File.join(path, file)
  end

end
