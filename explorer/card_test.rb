require 'minitest/autorun'
require_relative 'card'

class CardTest < MiniTest::Test

  def test_ace_equal_eleven
    card = Card.new("Clubs","A")
    assert_equal "11", card.value
  end

  def test_king_equal_ten
    card = Card.new("Clubs","K")
    assert_equal "10", card.value

  end

  def test_queen_equal_ten
    card = Card.new("Clubs","Q")
    assert_equal "10", card.value

  end

  def test_jack_equal_ten
    card = Card.new("Clubs","J")
    assert_equal "10", card.value

  end

  def test_card_for_face_suit_value
    card = Card.new("Clubs","A")
    assert_equal "Clubs", card.suit
    assert_equal "A", card.face
    assert_equal "10", card.value
  end

end
