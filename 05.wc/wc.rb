#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')
  output(ARGV, options['l'], options['w'], options['c'])
end

def output(filenames, is_line_count, is_word_count, is_byte_count)
  # オプション無しのときはすべてのオプション有りとみなす
  is_line_count = is_word_count = is_byte_count = true if !is_line_count && !is_word_count && !is_byte_count

  if filenames.empty?
    wc_without_argument(is_line_count, is_word_count, is_byte_count)
  else
    wc_with_argument(filenames, is_line_count, is_word_count, is_byte_count)
  end
end

def wc_without_argument(is_line_count, is_word_count, is_byte_count)
  text_buffer = readlines.join
  word_counts = count_word(text_buffer)
  show_counts(word_counts, is_line_count, is_word_count, is_byte_count, '')
end

def wc_with_argument(filenames, is_line_count, is_word_count, is_byte_count)
  total_line_count = total_word_count = total_byte_count = 0
  filenames.each do |filename|
    if File.file?(filename)
      text_buffer = File.read(filename)
      word_counts = count_word(text_buffer)
      show_counts(word_counts, is_line_count, is_word_count, is_byte_count, filename)

      total_line_count += word_counts[0]
      total_word_count += word_counts[1]
      total_byte_count += word_counts[2]
    elsif FileTest.directory?(filename)
      puts "wc: #{filename}: read: Is a directory"
    else
      puts "wc: #{filename}: open: No such file or directory"
    end
  end
  show_counts([total_line_count, total_word_count, total_byte_count], is_line_count, is_word_count, is_byte_count, 'total') if filenames.length > 1
end

def count_word(text)
  [
    text.count("\n"),
    text.split(' ').length,
    text.bytesize
  ]
end

# line数、word数、byte数の配列と各フラグからcount数をwcコマンド同様に出力
def show_counts(word_counts, is_line_count, is_word_count, is_byte_count, name)
  word_counts_aligned = word_counts.map { _1.to_s.rjust(8) }
  print word_counts_aligned[0] if is_line_count
  print word_counts_aligned[1] if is_word_count
  print word_counts_aligned[2] if is_byte_count
  puts " #{name}"
end

main
