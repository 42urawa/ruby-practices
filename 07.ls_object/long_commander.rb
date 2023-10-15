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
      create_segment(file_path)
    end

    segments.unshift("total #{total_blocks}") if @file_paths.length > 1
  end

  def max_digit_of_size
    file_stats.map { |file_stat| file_stat.size.to_s.length }.max
  end

  def total_blocks
    file_stats.map(&:blocks).sum
  end

  def file_stats
    @file_paths.map { |file_path| File::Stat.new(file_path) }
  end

  def create_segment(file_path)
    file_stat = File::Stat.new(file_path)
    mode = file_stat.mode.to_s(8).rjust(6, '0')
    type = {
      '02' => 'c',
      '04' => 'd',
      '01' => 'p',
      '06' => 'b',
      '10' => '-',
      '12' => 'l',
      '14' => 's'
    }[mode.slice(0, 2)]
    permission = mode.slice(3, 3).chars.map do |num|
      {
        '0' => '---',
        '1' => '--x',
        '2' => '-w-',
        '3' => '-wx',
        '4' => 'r--',
        '5' => 'r-x',
        '6' => 'rw-',
        '7' => 'rwx'
      }[num]
    end.join('')
    nlink = file_stat.nlink.to_s
    user = Etc.getpwuid(file_stat.uid).name
    group = Etc.getgrgid(file_stat.gid).name
    size = file_stat.size.to_s.rjust(max_digit_of_size)
    mtime = file_stat.mtime.year == Date.today.year ? file_stat.mtime.strftime('%b %e %H:%M') : file_stat.mtime.strftime('%b %e  %Y')
    name = File.basename(file_path)
    "#{type}#{permission}@ #{nlink} #{user}  #{group}  #{size} #{mtime} #{name}"
  end
end
