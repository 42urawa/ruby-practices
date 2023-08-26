# frozen_string_literal: true

class Game
  def initialize(marks_string)
    @marks_string = marks_string
  end

  def calculate_score
    frames = []
    result = 0
    @marks_string
      .split(',')
      .map { |mark| Shot.new(mark).to_pins }
      .flatten
      .each_slice(2) { |frame| frames << Frame.new(frame) }
    10.times do |frame|
      result += if frames[frame].strike? && frames[frame + 1].strike?
                  frames[frame].score + frames[frame + 1].score + frames[frame + 2].shots[0]
                elsif frames[frame].strike?
                  frames[frame].score + frames[frame + 1].score
                elsif frames[frame].spare?
                  frames[frame].score + frames[frame + 1].shots[0]
                else
                  frames[frame].score
                end
    end
    result
  end
end
