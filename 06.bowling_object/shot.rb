# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def to_pins
    pins = []
    if @mark == 'X'
      pins << 10
      pins << 0
    else
      pins << @mark.to_i
    end
    pins
  end
end
