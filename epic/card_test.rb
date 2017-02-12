require 'minitest/autorun'
require_relative 'card'

class CardTest < MiniTest::Test

  def test_ace_equal_eleven
    card = Card.new("Clubs","Ace")
    assert_equal 11, card.value
  end

  def test_king_equal_ten
    card = Card.new("Clubs","King")
    assert_equal 10, card.value

  end

  def test_queen_equal_ten
    card = Card.new("Clubs","Queen")
    assert_equal 10, card.value

  end

  def test_jack_equal_ten
    card = Card.new("Clubs","Jack")
    assert_equal 10, card.value

  end

  def test_card_for_face_suit_value
    card = Card.new("Clubs","Ace")
    assert_equal "Clubs", card.suit
    assert_equal "Ace", card.face
    assert_equal 11, card.value
  end

end
