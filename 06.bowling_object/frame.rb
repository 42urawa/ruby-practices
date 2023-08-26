# frozen_string_literal: true

class Frame
  attr_accessor :shots

  def initialize(shots)
    @shots = shots
  end

  def strike?
    shots[0] == 10
  end

  def spare?
    shots[0] != 10 && shots.sum == 10
  end

  def score
    shots.sum
  end
end
