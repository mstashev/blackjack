require 'tty'
require_relative 'card'
require_relative 'deck'

class Blackjack

  attr_accessor :p1hand,
                :househand,
                :prompt,
                :deck,
                :players,
                :player_input,
                :house_total,
                :player_total

  def initialize
    @prompt = TTY::Prompt.new
    @deck = Deck.new
    @p1hand = []
    @househand = []
    @players = [@p1hand, @househand]
    @player_input = nil
    @house_total = 0
    @player_total = 0
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
    # puts "Player hand: #{p1hand.inspect}"
    # puts "House hand: #{househand.inspect}"
    house_card = househand.first

    puts "House shows: #{house_card.to_s}"
    until player_input == "Stay" || is_over_21?(p1hand)
      playerturn(p1hand)
    end

    if house_total < player_total
      if player_total > 21
        puts "House wins!"
      else
        puts "You win!"
      end
    elsif player_total < house_total
      if  house_total > 21
        puts "Player wins!"
      else
        puts "House wins!"
      end
    else
      puts "You tied. House rules say, You win!"
    end
  end

  def houseturn(hand)
    house_total = 0
    hand.each do |card|
      house_total += card.value
    end
    if is_over_21?(househand) == true
      puts "Bust, Player wins"
      exit
    elsif is_21?(househand) == true
      puts "House gets Blackjack"
      exit
    end
    if house_total < 16
      hit(househand)
      # puts househand.inspect
      houseturn(househand)
    else
      puts "House has: "
      househand.each do |card|
        puts "#{card.to_s}"
      end
      puts "House hand total is #{house_total}."
      stay(house_total, "House")
    end
  end

  def playerturn(hand)
    player_total = 0
    p1hand.each do |card|
      player_total += card.value
    end
    puts "You have: "
    p1hand.each do |card|
      puts "#{card.to_s}"
    end
    puts "Your hand total is #{player_total}."
    if is_over_21?(p1hand) == true
      puts "Bust, dealer wins"
      exit
    elsif is_21?(p1hand) == true
      puts "Blackjack"
      exit
    else
      pick_an_option(player_total)
    end
  end

  def pick_an_option(response = nil, player_total)
    response = prompt.select("Would you like.", %w(Hit Stay)).downcase

    case response
    when "hit"
      hit(p1hand)
      playerturn(p1hand)
    when "stay"
      stay(player_total, "Player")
      houseturn(househand)
    end
  end

  def is_over_21?(hand)
    hand_total = 0
    hand.each do |card|
      hand_total += card.value
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
      hand_total += card.value
    end
    if hand_total == 21
      true
    else
      false
    end
  end

  def hit(hand)
    hand << deck.draw
  end

  def stay(total, who)
    @player_input = "Stay"
    if who == "Player"
      @player_total  = total
    elsif who == "House"
      @house_total = total
    else
      puts "Error"
      exit
    end
  end
end
Blackjack.new.play
