# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'
require_relative '../frame'
require_relative '../shot'

class BowlingObjectTest < Minitest::Test
  def test_a
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').score, 139
  end

  def test_b
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').score
  end

  def test_c
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').score
  end

  def test_d
    assert_equal 134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').score
  end

  def test_e
    assert_equal 144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8').score
  end

  def test_f
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').score
  end

  def test_g
    assert_equal 50, Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0').score
  end
end
