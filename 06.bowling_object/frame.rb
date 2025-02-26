# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  MAX_SHOT_SCORE = 10

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == MAX_SHOT_SCORE
  end

  def spare?
    @first_shot.score != MAX_SHOT_SCORE && @first_shot.score + @second_shot.score == MAX_SHOT_SCORE
  end
end
