require_relative 'deck'

class Shoe < Deck

  attr_accessor :shoe

  def initialize
    @shoe = []

    7.times do
      deck = Deck.new
      deck.cards.each do |card|
        shoe << card
      end
    end
    shoe.shuffle!
  end

  def draw
    @shoe.shift
  end

end
