#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

OPTIONS = ARGV.getopts('l', 'w', 'c')

def main
  output(ARGV, OPTIONS['l'], OPTIONS['w'], OPTIONS['c'])
end

def output(argv, is_line_count, is_word_count, is_character_count)
  # オプション無しのときはすべてのオプション有りとみなす
  is_line_count = is_word_count = is_character_count = true if !is_line_count && !is_word_count && !is_character_count

  if File.pipe?($stdin) && ARGV == []
    wc_with_pipe(is_line_count, is_word_count, is_character_count)
  else
    wc_without_pipe(argv, is_line_count, is_word_count, is_character_count)
  end
end

def wc_with_pipe(is_line_count, is_word_count, is_character_count)
  buf = ''
  while (str = $stdin.gets)
    buf += str
  end

  word_counts = word_counter(buf)
  show_counts(word_counts, is_line_count, is_word_count, is_character_count, '')
end

def wc_without_pipe(argv, is_line_count, is_word_count, is_character_count)
  total_line_count = total_word_count = total_character_count = 0

  argv.each do |arg|
    if FileTest.file? arg # file
      buf = File.read(arg)

      word_counts = word_counter(buf)
      show_counts(word_counts, is_line_count, is_word_count, is_character_count, arg)

      total_line_count += word_counts[0]
      total_word_count += word_counts[1]
      total_character_count += word_counts[2]
    elsif FileTest.directory? arg # directory
      puts "wc: #{arg}: read: Is a directory"
    else
      puts "wc: #{arg}: open: No such file or directory"
    end
  end

  show_counts([total_line_count, total_word_count, total_character_count], is_line_count, is_word_count, is_character_count, 'total')
end

# textからline数、word数、character数を配列で返す
def word_counter(text)
  [
    text.count("\n"),
    text.split(' ').length,
    text.length
  ]
end

# line数、word数、character数の配列と各フラグからcountをwcコマンド同様に出力
def show_counts(word_counts, is_line_count, is_word_count, is_character_count, name)
  word_counts_aligned = word_counts.map { _1.to_s.rjust(8) }
  print word_counts_aligned[0] if is_line_count
  print word_counts_aligned[1] if is_word_count
  print word_counts_aligned[2] if is_character_count
  puts " #{name}"
end

main
