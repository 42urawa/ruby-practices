# frozen_string_literal: true

class Game
  # attr_accessor :frames

  def initialize(frames)
    @frames = frames
  end

  def frame_to_score
    point = 0
    10.times do |frame|
      point += if @frames[frame][0] == 10 # strike
                 if @frames[frame + 1][0] == 10
                   @frames[frame].sum + @frames[frame + 1].sum + @frames[frame + 2][0]
                 else
                   @frames[frame].sum + @frames[frame + 1].sum
                 end
               elsif @frames[frame].sum == 10 # spare
                 @frames[frame].sum + @frames[frame + 1][0]
               else
                 @frames[frame].sum
               end
    end
    point
  end

  def test
    puts 'testしたよ'
  end
end
