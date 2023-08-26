# frozen_string_literal: true

class Frame
  # attr_accessor :shots

  def initialize(shots)
    @shots = shots
  end

  def shot_to_frame
    frames = []
    @shots.each_slice(2) do |shot|
      frames << shot
    end
    frames
  end
end
