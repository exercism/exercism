class VariedResponses
  SENTENCE_STARTERS = [
    "I'm curious about why…",
    "From reading your code, I learned…",
    "You might consider…",
    "One thing that would have helped me better understand your code is…",
    "I like how you…",
    "You might simplify this by…",
  ].freeze

  def self.sentence_starter
    SENTENCE_STARTERS.sample
  end
end
