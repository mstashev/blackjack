require 'tty'
require_relative 'card'
require_relative 'deck'
require 'pry'

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
    if is_21?(househand) == true
      puts 'House has Blackjack. House wins!'
    else
      until player_input == 'Stay' || over_21?(p1hand) || (p1hand.count == 6 && hand_total(p1hand) < 21)
        playerturn(p1hand)
      end

      if house_total < player_total
        puts 'Player wins!'
      elsif player_total < house_total
        puts 'House wins!'
      elsif player_total == house_total
        if p1hand.count < househand.count
          puts 'House wins!'
        elsif p1hand.count == househand.count
          puts 'You win!'
        else
          puts 'You win!'
        end
      end
    end
  end

  def houseturn(hand)
    house_total = hand_total(househand)
    if over_21?(househand) == true
      puts 'Bust, Player wins'
      exit
    elsif is_21?(househand) == true
      puts 'Blackjack. House wins.'
      exit
    end
    if house_total < 16
      hit(househand)
      # puts househand.inspect
      houseturn(househand)
    else
      puts 'House has: '
      househand.each do |card|
        puts "#{card.to_s}"
      end
      puts "House hand total is #{house_total}."
      stay(house_total, 'House')
    end
  end

  def playerturn(hand)
    player_total = hand_total(p1hand)
    puts 'You have: '
    p1hand.each do |card|
      puts "#{card.to_s}"
    end
    puts "Your hand total is #{player_total}."
    puts "Your card count is #{p1hand.count}."
    if over_21?(p1hand) == true
      puts 'Bust, dealer wins'
      exit
    elsif is_21?(p1hand) == true
      puts 'Blackjack'
      exit
    else
      pick_an_option(player_total)
    end
  end

  def pick_an_option(response = nil, player_total)
    response = prompt.select('Would you like.', %w(Hit Stay)).downcase

    case response
    when 'hit'
      hit(p1hand)
      playerturn(p1hand)
    when 'stay'
      # binding.pry
      stay(player_total, 'Player')
      houseturn(househand)
    end
  end

  def over_21?(hand)
    handtotal = hand_total(hand)
    # binding.pry
    if handtotal <= 21
      false
    else
      true
    end
  end

  def is_21?(hand)
    handtotal = hand_total(hand)
    if handtotal == 21
      true
    else
      false
    end
  end

  def hit(hand)
    hand << deck.draw
  end

  def stay(total, who)
    @player_input = 'Stay'
    if    who == 'Player'
      @player_total = total
    elsif who == 'House'
      @house_total  = total
    else
      puts 'Error'
      exit
    end
  end

  def hand_total(hand)
    hand_total = 0
    hand.each do |card|
      # binding.pry
      hand_total += card.value
    end
    hand_total
    # binding.pry
  end
end
Blackjack.new.play
