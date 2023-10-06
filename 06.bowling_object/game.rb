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
    bonus_score_exclude_ninth_strike =
      @frames.slice(1..8)
             .map.with_index { |_f, i| @frames[i + 1].first_shot.score + @frames[i + 2].first_shot.score }
             .select.with_index { |_s, i| @frames[i].strike? && @frames[i + 1].strike? }.sum
    ninth_bonus_score = if @frames[8].strike? && @frames[9].strike?
                          @frames[9].first_shot.score + @frames[9].second_shot.score
                        else
                          0
                        end
    bonus_score_exclude_ninth_strike + ninth_bonus_score
  end

  def single_strike_bonus
    @frames.slice(1..).map { |frame| frame.first_shot.score + frame.second_shot.score }
           .select.with_index { |_s, i| @frames[i].strike? && !@frames[i + 1].strike? }.sum
  end

  def spare_bonus
    @frames.slice(1..).map { |frame| frame.first_shot.score }.select.with_index { |_s, i| @frames[i].spare? }.sum
  end
end
