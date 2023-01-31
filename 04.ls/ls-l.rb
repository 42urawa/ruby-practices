#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

OPTIONS = ARGV.getopts('l')

def main
  path = ARGV[0]

  if path.nil?
    names = path_names = Dir.glob('*')
  elsif FileTest.directory? path
    directory_path = path[-1] == '/' ? path : "#{path}/"
    path_names = Dir.glob("#{directory_path}*")
    names = (Dir.glob("#{directory_path}*").map do |p|
      p.split('/')[-1]
    end).to_a
  elsif FileTest.file? path
    path_names = [path]
    names = [path.split('/')[-1]]
  else
    puts "ls: #{ARGV[0]}: No such file or directory"
    exit
  end

  output(names, path_names, OPTIONS['l'])
end

# ファイル名配列を転置（縦並び出力用）
def arrange_vertical(array, slice_count = 3)
  array_display = []
  row_count = array.length.quo(slice_count).ceil
  array.each_slice(row_count) { |s| array_display << s }
  (row_count - array_display[-1].length).times { array_display[-1] << '' }
  array_display.transpose
end

# ファイル名情報を標準出力する（-lオプション無し）
def ls(arrays)
  arrays.each do |array|
    array.each do |a|
      print a
    end
    print "\n"
  end
end

# 異なる文字数の文字列配列を左右スペース埋めして同文字数の配列にして返す　※日本語対応済
def align(file_informations, additional_space = 1, reference_position: true)
  word_counts = (file_informations.map do |information|
    (information.bytesize + information.length) / 2 # 日本語を2文字分とした文字数を計算
  end).to_a
  max_length = word_counts.max + additional_space
  file_informations.map do |information|
    word_count_ja = (information.bytesize - information.length) / 2 # 文字列中に含まれる日本語文字数
    if reference_position
      information.rjust(max_length - word_count_ja)
    else
      information.ljust(max_length - word_count_ja)
    end
  end
end

# ファイル名の配列からFile::Statクラスの配列を取得
def files(path_names)
  path_names.map do |path_name|
    File::Stat.new(path_name)
  end
end

# File::Statクラスの配列からブロック数の配列を取得
def blocks(files)
  files.map(&:blocks)
end

# File::Statクラスの配列からモードの配列を取得
def modes(files)
  files.map do |file|
    file.mode.to_s(8).rjust(6, '0')
  end
end

# モードの配列からファイル種別の配列を取得
def types(modes)
  modes.map do |mode|
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
end

# モードの配列からパーミッションの配列を取得
def permissions(modes)
  modes.map do |mode|
    (mode.slice(3, 3).chars.map do |m|
      [m.to_i.to_s(2).rjust(3, '0').chars, %w[r w x]].transpose.map do |p|
        p[0] == '1' ? p[1] : '-'
      end
    end).join
  end
end

# File::Statクラスの配列からnlinkの配列を取得
def nlinks(files)
  align(files.map do |file|
    file.nlink.to_s
  end, 1)
end

# File::Statクラスの配列からユーザ名の配列を取得
def users(files)
  align(files.map do |file|
    Etc.getpwuid(file.uid).name
  end)
end

# File::Statクラスの配列からグループ名の配列を取得
def groups(files)
  align(files.map do |file|
    Etc.getgrgid(file.gid).name
  end, 2)
end

# File::Statクラスの配列からファイルサイズの配列を取得
def sizes(files)
  align(files.map do |file|
    file.size.to_s
  end, 2)
end

# File::Statクラスの配列から更新時刻の配列を取得
def mtimes(files)
  align(files.map do |file|
    if file.mtime.year == Date.today.year
      file.mtime.strftime('%_m %e %H:%M')
    else
      file.mtime.strftime('%_m %e  %Y')
    end
  end)
end

# ファイル名（先頭に半角スペース1有）の配列を取得
def names_option_l(names)
  names.map { |f| f.prepend(' ') }
end

def ls_detailed(names, path_names)
  files = files(path_names)
  blocks = blocks(files)
  modes = modes(files)
  types = types(modes)
  permissions = permissions(modes)
  nlinks = nlinks(files)
  users = users(files)
  groups = groups(files)
  sizes = sizes(files)
  mtimes = mtimes(files)
  names_option_l = names_option_l(names)

  puts "total #{blocks.sum}"
  [types, permissions, nlinks, users, groups, sizes, mtimes, names_option_l].transpose.each { |s| puts s.join }
end

def output(names, path_names, is_detailed)
  if is_detailed
    ls_detailed(names, path_names)
  else
    names_aligned = align(names, 1, reference_position: false) # 左づめで名前を配置
    names_vertically_arranged = arrange_vertical(names_aligned)
    ls(names_vertically_arranged)
  end
end

main
