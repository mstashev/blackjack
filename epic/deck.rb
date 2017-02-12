require_relative 'card'

class Deck

  attr_accessor :cards

  def initialize
    @cards = []
    Card.suits.each do |suit|
      Card.faces.each do |face|
        cards << Card.new(suit, face)
      end
    end
    cards.shuffle!
  end

  def draw
    @cards.shift
  end

  def dry?
    cards.empty?
  end

end
