# frozen_string_literal: true

class LongCommander
  def initialize(file_paths)
    @file_paths = file_paths
  end

  def show
    puts segments
  end

  def segments
    max_digit_of_size = @file_paths.map do |file_path|
      File::Stat.new(file_path).size.to_s.length
    end.max

    total_blocks = @file_paths.map do |file_path|
      File::Stat.new(file_path).blocks
    end.sum

    segments = @file_paths.map do |file_path|
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
      type + permission + '@ ' + nlink + ' ' + user + '  ' + group + '  ' + size + ' ' + mtime + ' ' + name
    end

    segments.unshift("total #{total_blocks}") if @file_paths.length > 1
  end

  # def file_stats
  #   @file_paths.map { File::Stat.new(file_path) }
  # end

  # def modes
  #   @file_paths.map { File::Stat.new(file_path) }.map { _1.mode.to_s(8).rjust(6, '0') }
  # end
end
