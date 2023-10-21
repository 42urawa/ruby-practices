# frozen_string_literal: true

class Segment
  def initialize(file_path)
    @file_path = file_path
  end

  def type
    {
      '02' => 'c',
      '04' => 'd',
      '01' => 'p',
      '06' => 'b',
      '10' => '-',
      '12' => 'l',
      '14' => 's'
    }[mode.slice(0, 2)]
  end

  def permission
    mode.slice(3, 3).chars.map do |num|
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
  end

  def nlink
    file_stat.nlink.to_s
  end

  def user
    Etc.getpwuid(file_stat.uid).name
  end

  def group
    Etc.getgrgid(file_stat.gid).name
  end

  def size
    file_stat.size.to_s
  end

  def mtime
    file_stat.mtime.year == Date.today.year ? file_stat.mtime.strftime('%b %e %H:%M') : file_stat.mtime.strftime('%b %e  %Y')
  end

  def name
    FileTest.file?(@file_path) ? @file_path : File.basename(@file_path)
  end

  def blocks
    file_stat.blocks
  end

  private

  def file_stat
    File::Stat.new(@file_path)
  end

  def mode
    file_stat.mode.to_s(8).rjust(6, '0')
  end
end
