class Robot
  def name
    @name ||= "#{prefix}#{suffix}"
  end

  def reset
    @name = nil
  end

  private

  def prefix
    alphabet.shuffle[0..1].join('')
  end

  def suffix
    rand(899) + 100
  end

  def alphabet
    %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
  end
end

