class Breakdown

  def self.of(language)
    new language, compute(language)
  end

  def self.compute(language)
    raise "Reimplement This"
    match = {"$match" => {"state" => "pending", "l" => language}}
    group = {"$group" => {"_id" => "$s", count: {"$sum" => 1}}}
    Submission.collection.aggregate([match, group])
  end

  attr_reader :language
  def initialize(language, aggregate)
    @language = language
    @aggregate = aggregate
  end

  def [](exercise)
    histogram[exercise]
  end

  def histogram
    @histogram ||= aggregate.each_with_object(Hash.new(0)) {|entry, counts|
      counts[exercise(entry["_id"])] = entry["count"]
    }
  end

  def exercise(slug)
    Exercise.new(language, slug)
  end

  private

  def aggregate
    @aggregate
  end

end
