# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

mark_string = ARGV[0]
shot = Shot.new(mark_string)
frame = Frame.new(shot.mark_to_shot)
game = Game.new(frame.shot_to_frame)

p game.frame_to_score
