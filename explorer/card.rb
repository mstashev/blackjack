class Card
  include Comparable

  def self.faces
    ("2".."10").to_a + %w(Jack Queen King Ace)
  end

  def self.suits
    %w(Clubs Spades Diamonds Hearts)
  end

  attr_accessor :suit, :face, :value

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = setValue
  end

  def setValue
    if face.to_i != 0
      face.to_i
    elsif face == "A"
      11
    else
      10
    end
  end

  def to_s
    "a #{face} of #{suit}"
  end

  def <=>(other)
    value <=> other.value
  end

  def +(other)
    value + other.value
  end

end
