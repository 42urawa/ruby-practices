# frozen_string_literal: true

class LongCommander
  def initialize(file_paths:, is_file_path:)
    @segments = file_paths.map { |file_path| Segment.new(file_path) }
    @is_file_path = is_file_path
  end

  def show
    puts segments
  end

  private

  def segments
    segments = @segments.map { |segment| segment.segment(max_digit_of_nlink:, max_digit_of_size:, is_file_path: @is_file_path) }

    @is_file_path ? segments : segments.unshift("total #{total_blocks}")
  end

  def max_digit_of_nlink
    @segments.map { |segment| segment.nlink.to_s.length }.max
  end

  def max_digit_of_size
    @segments.map { |segment| segment.size.to_s.length }.max
  end

  def total_blocks
    @segments.map(&:blocks).sum
  end
end
