class Allergies
  ALLERGENS = {
    1 => "eggs",
    2 => "peanuts",
    4 => "shellfish",
    8 => "strawberries",
    16 => "tomatoes",
    32 => "chocolate",
    64 => "pollen",
    128 => "cats"
  }

  def initialize(flags)
    @flags = flags
  end

  # This project uses a concept called bitflagging where each new allergen
  # is a power of 2. If you want to see how this works, try using to_s(2)
  # to turn @flags into a binary string. `@flags.to_s(2) #=> 100010` when
  # @flags == 34. The first 1 is chocolate, the second 1 is peanuts. 32 + 2
  # == 34.
  # This works because even if all the allergens below 'cats' were active,
  # their total value would be 127. So we can ask what is the largest power
  # of two that fits in the allergy number.
  def list
    allergies = []
    ALLERGENS.each do |bitflag, allergen|
      # Use a Binary AND to see if this allergen's bit is active or not.
      if (@flags & bitflag) > 0
        allergies << allergen
      end
    end
    return allergies
  end

  def allergic_to?(allergen)
    list.include?(allergen)
  end
end