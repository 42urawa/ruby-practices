# frozen_string_literal: true

class Game
  def initialize(marks_str)
    marks_with_zero = []
    marks_str.split(',').each do |mark|
      if mark == 'X'
        marks_with_zero << 'X'
        marks_with_zero << '0'
      else
        marks_with_zero << mark
      end
    end

    framed_marks = []
    marks_with_zero.each_slice(2) { |frame| framed_marks << frame }
    tenth_frame = framed_marks.slice(9..).flatten.join('').gsub(/X0/, 'X').split('')

    @frames = (framed_marks.slice(..8) << tenth_frame).map { |frame| Frame.new(*frame) }
  end

  def score
    score_without_bonus + double_strike_bonus + single_strike_bonus + spare_bonus
  end

  def score_without_bonus
    @frames.map(&:score).sum
  end

  def double_strike_bonus
    (0..8).sum do |i|
      next 0 unless @frames[i].strike? && @frames[i + 1].strike?

      if i < 8
        @frames[i + 1].first_shot.score + @frames[i + 2].first_shot.score
      else
        @frames[i + 1].first_shot.score + @frames[i + 1].second_shot.score
      end
    end
  end

  def single_strike_bonus
    (0..8).sum do |i|
      next 0 unless @frames[i].strike? && !@frames[i + 1].strike?

      @frames[i + 1].first_shot.score + @frames[i + 1].second_shot.score
    end
  end

  def spare_bonus
    (0..8).sum do |i|
      next 0 unless @frames[i].spare?

      @frames[i + 1].first_shot.score
    end
  end
end
