# frozen_string_literal: true

class Shot
  # attr_accessor :marks

  def initialize(mark_string)
    @marks = mark_string.split(',')
  end

  def mark_to_shot
    shots = []
    @marks.each do |mark|
      if mark == 'X'
        shots << 10
        shots << 0
      else
        shots << mark.to_i
      end
    end
    shots
  end
end
