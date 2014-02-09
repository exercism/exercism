class Readme
  include Named

  attr_reader :slug, :dir, :help

  def initialize(slug, dir="./assignments", help=nil)
    @slug = slug
    @dir = dir
    @help = help
  end

  def text
    @text ||= <<-README
# #{name}

#{blurb}

#{instructions}
#{help}
## Source

#{source} [view source](#{source_url})
README
  end

  private

  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
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
    read "#{slug}.md"
  end

  def data
    @data ||= YAML.load read "#{slug}.yml"
  end

  def read(file)
    File.read path_to(file)
  end

  def path_to(file)
    File.join(dir, 'shared', file)
  end
end
