class Assignment

  attr_reader :path, :language, :slug, :data_dir
  def initialize(language, slug, path)
    @language = language
    @slug = slug
    @data_dir = path
    @path = File.join(path, language, slug)
  end

  def filenames
    Dir.glob("#{path}/**/**").reject {|f| f[/example/] || File.directory?(f)}.map {|f| f.gsub("#{path}/", '')}
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
    filenames.find {|f| f[/test/]}
  end

  def files
    @files ||= Hash[construct_files]
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

  def construct_files
    filenames.reduce({}) do |files, name|
      files.merge(name => read(name))
    end.merge("README.md" => readme).sort_by {|name, text| name.downcase}
  end
end

