# frozen_string_literal: true

class Game
  def initialize(marks_string)
    marks_with_zero = []
    marks_string
      .split(',')
      .each do |mark|
      if mark == 'X'
        marks_with_zero << 'X'
        marks_with_zero << '0'
      else
        marks_with_zero << mark
      end
    end

    framed_marks = []
    marks_with_zero.each_slice(2) { |frame| framed_marks << frame }

    @first_frame = Frame.new(*framed_marks[0])
    @second_frame = Frame.new(*framed_marks[1])
    @third_frame = Frame.new(*framed_marks[2])
    @fourth_frame = Frame.new(*framed_marks[3])
    @fifth_frame = Frame.new(*framed_marks[4])
    @sixth_frame = Frame.new(*framed_marks[5])
    @seventh_frame = Frame.new(*framed_marks[6])
    @eighth_frame = Frame.new(*framed_marks[7])
    @ninth_frame = Frame.new(*framed_marks[8])

    tenth_frame_shots = framed_marks.slice(9..).flatten

    @tenth_frame = if tenth_frame_shots[0] == 'X' && tenth_frame_shots[2] == 'X' ## double, turkey
                     Frame.new(*[] << tenth_frame_shots[0] << tenth_frame_shots[2] << tenth_frame_shots[4])
                   elsif tenth_frame_shots[0] == 'X' ## single
                     Frame.new(*tenth_frame_shots.select.with_index { |_value, index| index != 1 })
                   else
                     Frame.new(*tenth_frame_shots.slice(0, 3))
                   end
  end

  def score
    result = 0

    result += score_without_bonus
    result += double_strike_bonus
    result += single_strike_bonus
    result += spare_bonus

    result
  end

  def score_without_bonus
    @first_frame.score +
      @second_frame.score +
      @third_frame.score +
      @fourth_frame.score +
      @fifth_frame.score +
      @sixth_frame.score +
      @seventh_frame.score +
      @eighth_frame.score +
      @ninth_frame.score +
      @tenth_frame.score
  end

  def double_strike_bonus
    bonus_score = 0
    bonus_score += @second_frame.first_shot.score + @third_frame.first_shot.score if @first_frame.strike? && @second_frame.strike?
    bonus_score += @third_frame.first_shot.score + @fourth_frame.first_shot.score if @second_frame.strike? && @third_frame.strike?
    bonus_score += @fourth_frame.first_shot.score + @fifth_frame.first_shot.score if @third_frame.strike? && @fourth_frame.strike?
    bonus_score += @fifth_frame.first_shot.score + @sixth_frame.first_shot.score if @fourth_frame.strike? && @fifth_frame.strike?
    bonus_score += @sixth_frame.first_shot.score + @seventh_frame.first_shot.score if @fifth_frame.strike? && @sixth_frame.strike?
    bonus_score += @seventh_frame.first_shot.score + @eighth_frame.first_shot.score if @sixth_frame.strike? && @seventh_frame.strike?
    bonus_score += @eighth_frame.first_shot.score + @ninth_frame.first_shot.score if @seventh_frame.strike? && @eighth_frame.strike?
    bonus_score += @ninth_frame.first_shot.score + @tenth_frame.first_shot.score if @eighth_frame.strike? && @ninth_frame.strike?

    bonus_score
  end

  def single_strike_bonus
    bonus_score = 0
    bonus_score += @second_frame.first_shot.score + @second_frame.second_shot.score if @first_frame.strike? && !@second_frame.strike?
    bonus_score += @third_frame.first_shot.score + @third_frame.second_shot.score if @second_frame.strike? && !@third_frame.strike?
    bonus_score += @fourth_frame.first_shot.score + @fourth_frame.second_shot.score if @third_frame.strike? && !@fourth_frame.strike?
    bonus_score += @fifth_frame.first_shot.score + @fifth_frame.second_shot.score if @fourth_frame.strike? && !@fifth_frame.strike?
    bonus_score += @sixth_frame.first_shot.score + @sixth_frame.second_shot.score if @fifth_frame.strike? && !@sixth_frame.strike?
    bonus_score += @seventh_frame.first_shot.score + @seventh_frame.second_shot.score if @sixth_frame.strike? && !@seventh_frame.strike?
    bonus_score += @eighth_frame.first_shot.score + @eighth_frame.second_shot.score if @seventh_frame.strike? && !@eighth_frame.strike?
    bonus_score += @ninth_frame.first_shot.score + @ninth_frame.second_shot.score if @eighth_frame.strike? && !@ninth_frame.strike?
    bonus_score += @tenth_frame.first_shot.score + @tenth_frame.second_shot.score if @ninth_frame.strike?

    bonus_score
  end

  def spare_bonus
    bonus_score = 0
    bonus_score += @second_frame.first_shot.score if @first_frame.spare?
    bonus_score += @third_frame.first_shot.score if @second_frame.spare?
    bonus_score += @fourth_frame.first_shot.score if @third_frame.spare?
    bonus_score += @fifth_frame.first_shot.score if @fourth_frame.spare?
    bonus_score += @sixth_frame.first_shot.score if @fifth_frame.spare?
    bonus_score += @seventh_frame.first_shot.score if @sixth_frame.spare?
    bonus_score += @eighth_frame.first_shot.score if @seventh_frame.spare?
    bonus_score += @ninth_frame.first_shot.score if @eighth_frame.spare?
    bonus_score += @tenth_frame.first_shot.score if @ninth_frame.spare?

    bonus_score
  end
end
