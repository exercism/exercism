require 'exercism/locale'

class FakeTrail
  def language
    locale.language
  end
end

class FakePythonCurriculum < FakeTrail
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('python', 'py', 'py')
  end
end

class FakeRubyCurriculum < FakeTrail
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('ruby', 'rb', 'rb')
  end
end

class FakeGoCurriculum < FakeTrail
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('go', 'go', 'go')
  end
end

class FakeCurriculum < FakeTrail
  def slugs
    %w(one two)
  end

  def locale
    Locale.new('fake', 'ext', 'test')
  end
end
