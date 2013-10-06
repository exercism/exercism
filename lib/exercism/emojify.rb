require 'exercism/emojify'

class Emojify
  PATH = File.expand_path("..", __FILE__)

  def self.convert(input)
    self.new(input).convert
  end

  def initialize(input)
    @input = input 
  end

  def convert
    @input.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if names.include?($1)
        '<img alt="' + $1 + '" height="20" src="' + "../img/emoji/#{$1}.png" + '" style="vertical-align:middle" width="20" />'
      else
        match
      end
    end
  end

  def path
    PATH
  end

  def images_path
    File.expand_path("../../app/public/img", __FILE__)
  end


  def names
    @names ||= Dir["#{images_path}/emoji/*.png"].sort.map { |fn| File.basename(fn, '.png') }
  end
end
