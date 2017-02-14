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
    @games_counter = 0
  end

  def self.games_counter=(games_counter=0)
      @games_counter = games_counter
  end

  def self.games_counter
    @games_counter ||= 0
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

    puts "House shows: #{house_card}"
    if is_21?(househand)
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
    ask_for_rematch
  end

  def houseturn(hand)
    house_total = hand_total(hand)
    if over_21?(hand)
      puts 'Bust, Player wins'
      ask_for_rematch
    elsif is_21?(hand)
      puts 'Blackjack. House wins.'
      ask_for_rematch
    end
    if house_total < 16
      hit(hand)
      # puts househand.inspect
      houseturn(hand)
    else
      puts 'House has: '
      hand.each do |card|
        puts card.to_s
      end
      puts "House hand total is #{house_total}."
      stay(house_total, 'House')
    end
  end

  def playerturn(hand)
    player_total = hand_total(hand)
    puts 'You have: '
    p1hand.each do |card|
      puts card.to_s
    end
    puts "Your hand total is #{player_total}."
    puts "Your card count is #{p1hand.count}."
    if over_21?(hand)
      puts 'Bust, dealer wins'
      ask_for_rematch
    elsif is_21?(hand)
      puts 'Blackjack'
      ask_for_rematch
    else
      pick_an_option(player_total)
    end
  end

  def pick_an_option(player_total, response = nil)
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
    if who == 'Player'
      @player_total = total
    elsif who == 'House'
      @house_total  = total
    else
      puts 'Error'
      ask_for_rematch
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

  def ask_for_rematch
    self.class.games_counter += 1
    puts "You've played #{self.class.games_counter} games."
    response = prompt.yes?('Wanna go again?')
    if response
      Blackjack.new.play
    else
      puts 'Goodbye'
      exit
    end
  end
end

Blackjack.new.play
