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
    directory = Pathname.new(locale.test_directory)
    file = directory + "#{slug}_test.#{locale.test_extension}"
    file.to_s
  end

  def example
    @example ||= read(example_file)
  end

  def example_file
    "example.#{locale.code_extension}"
  end

  def additional_files
    locale.additional_files.reduce({}) do |hash, file|
      hash[file] = read(file)
      hash
    end
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
    @instructions ||= read_shared instructions_file
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
    @data ||= YAML.load read_shared data_file
  end

  def data_file
    "#{slug}.yml"
  end

  def instructions_file
    "#{slug}.md"
  end

  def read(file)
    File.read path_to(file)
  end

  def path_to(file)
    File.join(path, file)
  end

  def read_shared(file)
    File.read path_to_shared(file)
  end

  def path_to_shared(file)
    File.join(data_dir, 'shared', file)
  end

end

