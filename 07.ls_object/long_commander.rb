# frozen_string_literal: true

class LongCommander
  def initialize(file_paths)
    @file_paths = file_paths
  end

  def show
    puts segments
  end

  private

  def segments
    segments = @file_paths.map do |file_path|
      segment = Segment.new(file_path)

      type = segment.type
      permission = segment.permission
      nlink = segment.nlink.rjust(max_digit_of_nlink)
      user = segment.user
      group = segment.group
      size = segment.size.rjust(max_digit_of_size)
      mtime = segment.mtime
      name = @file_paths.length == 1 ? segment.name : File.basename(segment.name)

      "#{type}#{permission}@ #{nlink} #{user}  #{group}  #{size} #{mtime} #{name}"
    end

    @file_paths.length == 1 ? segments : segments.unshift("total #{total_blocks}")
  end

  def max_digit_of_nlink
    @file_paths.map { |file_path| Segment.new(file_path).nlink.to_s.length }.max
  end

  def max_digit_of_size
    @file_paths.map { |file_path| Segment.new(file_path).size.to_s.length }.max
  end

  def total_blocks
    @file_paths.map { |file_path| Segment.new(file_path).blocks }.sum
  end
end
