require 'tty'
require_relative 'card'
require_relative 'deck'

class Blackjack

  attr_accessor :p1hand,
                :househand,
                :prompt,
                :deck,
                :players

  def initialize
    @prompt = TTY::Prompt.new
    @deck = Deck.new
    @p1hand = []
    @househand = []
    @players = [@p1hand, @househand]
  end

  def deal(players)
    2.times do
      players.each do |player|
        player << deck.draw
      end
    end
  end

  def play
    deal(players)
    puts p1hand.inspect
    puts househand.inspect

   48.times do
     houseturn(househand)
   end

    # if househand < 16
    #   hit(househand)
    # else
    #   stay
    # end

  end

  def houseturn(hand)
    hand_total =  hand.each do |card|
                    hand_total + card.value
                  end
    if hand_total < 16
      hit(househand)
    else
      stay
    end
  end

  def playerturn(hand)
    hand_total =  hand.each do |card|
                    hand_total + card.value
                  end
    

  end




  def is_over_21?(hand)
    hand_total = 0
    hand.each do |card|
      hand_total + card.value
    end
    if hand_total <= 21
      false
    else
      true
    end
  end

  def is_21?(hand)
    hand_total = 0
    hand.each do |card|
      hand_total + card.value
    end
    if hand_total == 21
      true
    else
      false
    end
  end

  def hit(hand)
    hand << deck.draw
    is_over_21?(hand)
  end

  def stay
    exit
  end



end
Blackjack.new.play
