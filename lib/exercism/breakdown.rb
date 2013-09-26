class Breakdown

  def self.of(language)
    new language
  end

  def initialize(language)
    @language = language
  end

  def [](exercise)
    histogram[exercise]
  end

  private

  def histogram
    @histogram ||= begin
      aggregate.each_with_object(Hash.new(0)) {|entry, counts|
        counts[exercise(entry["slug"])] = entry["c"]
      }
    end
  end

  def aggregate
    @aggregate ||= Submission.pending.where(language: @language).
                                      group(:slug).
                                      select("slug, COUNT(*) as c")
  end

  def exercise(slug)
    Exercise.new(@language, slug)
  end

end
