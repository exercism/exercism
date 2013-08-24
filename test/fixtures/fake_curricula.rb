require 'exercism/locale'

class FakeRubyCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('ruby', 'rb', 'rb')
  end
end

class FakeGoCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('go', 'go', 'go')
  end
end

class FakeCurriculum
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('fake', 'ext', 'test')
  end
end
