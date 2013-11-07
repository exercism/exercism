class Assignment

  attr_reader :path, :language, :slug, :data_dir
  def initialize(language, slug, path)
    @language = language
    @slug = slug
    @data_dir = path
    @path = File.join(path, language, slug)
  end

  def files
    Dir.glob("#{path}/**/**").reject {|f| f[/example/] || File.directory?(f)}.map {|f| f.gsub("#{path}/", '')}
  end

  def name
    exercise.name
  end

  def exercise
    @exercise ||= Exercise.new(language, slug)
  end

  def stub
    if @checked_stub then
      @stub == :no_stub ? nil : @stub
    else
      @stub = read_stub_file
      @checked_stub = true
      stub
    end
  end

  def stub_file
    if @checked_stub_file then
      @stub_file == :no_stub ? nil : @stub_file
    else
      fn = stub_filename
      @stub_file = fn ? fn.sub("_stub", "") : :no_stub
      @checked_stub_file = true
      stub_file
    end
  end

  def tests
    @tests ||= read(test_file)
  end

  def test_file
    files.find {|f| f[/test/]}
  end

  def additional_files
    additional_filenames.reduce({}) do |hash, file|
      hash[file] = read(file)
      hash
    end
  end

  def additional_filenames
    files.reject {|f| f[/test/] || f[/stub/]}
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

  def stub_filename
    files.find {|f| f[/_stub/]}
  end

  def read_stub_file
    fn = stub_filename
    fn ? read(fn) : :no_stub
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

