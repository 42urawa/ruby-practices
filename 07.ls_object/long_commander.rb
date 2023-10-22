# frozen_string_literal: true

class LongCommander
  def initialize(file_paths:, is_file_path:)
    @file_paths = file_paths
    @is_file_path = is_file_path
    @max_digit_of_nlink = @file_paths.map { |file_path| Segment.new(file_path:).nlink.to_s.length }.max
    @max_digit_of_size = @file_paths.map { |file_path| Segment.new(file_path:).size.to_s.length }.max
  end

  def show
    puts segments
  end

  private

  def segments
    segments = @file_paths.map do |file_path|
      segment = Segment.new(file_path:, is_file_path: @is_file_path, max_digit_of_nlink: @max_digit_of_nlink, max_digit_of_size: @max_digit_of_size)

      segment.segment
    end

    @is_file_path ? segments : segments.unshift("total #{total_blocks}")
  end

  def total_blocks
    @file_paths.map { |file_path| Segment.new(file_path:).blocks }.sum
  end
end
