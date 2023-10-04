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

    tenth_frame_shots_with_zero = framed_marks.slice(9..).flatten

    tenth_frame = if tenth_frame_shots_with_zero[0] == 'X' && tenth_frame_shots_with_zero[2] == 'X' ## double, turkey
                    [] << tenth_frame_shots_with_zero[0] << tenth_frame_shots_with_zero[2] << tenth_frame_shots_with_zero[4]
                  elsif tenth_frame_shots_with_zero[0] == 'X' ## single
                    tenth_frame_shots_with_zero.select.with_index { |_value, index| index != 1 }
                  else
                    tenth_frame_shots_with_zero.slice(0, 3)
                  end

    @frames = (framed_marks.slice(..8) << tenth_frame).map { |frame| Frame.new(*frame) }
  end

  def score
    score_without_bonus + double_strike_bonus + single_strike_bonus + spare_bonus
  end

  def score_without_bonus
    @frames.map(&:score).sum
  end

  def double_strike_bonus
    bonus_score = 0

    0.upto(7) do |i|
      bonus_score += @frames[i + 1].first_shot.score + @frames[i + 2].first_shot.score if @frames[i].strike? && @frames[i + 1].strike?
    end

    bonus_score
  end

  def single_strike_bonus
    bonus_score = 0

    0.upto(7) do |i|
      bonus_score += @frames[i + 1].first_shot.score + @frames[i + 1].second_shot.score if @frames[i].strike? && !@frames[i + 1].strike?
    end

    bonus_score += @frames[9].first_shot.score + @frames[9].second_shot.score if @frames[8].strike?
    bonus_score
  end

  def spare_bonus
    bonus_score = 0

    0.upto(8) do |i|
      bonus_score += @frames[i + 1].first_shot.score if @frames[i].spare?
    end

    bonus_score
  end
end
