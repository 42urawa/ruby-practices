# frozen_string_literal: true

require 'date'
require 'optparse'

options = ARGV.getopts('y:', 'm:')

year  = (options['y'] ||= Date.today.year).to_i
month = (options['m'] ||= Date.today.month).to_i

date_beginning = Date.new(year, month, 1)
date_end       = Date.new(year, month, -1)

puts ''
puts "       #{month}月 #{year}"
puts ' 日 月 火 水 木 金 土'
print ' ' * 3 * date_beginning.wday

(date_beginning..date_end).each do |date|
  print date.day.to_s.rjust(3)
  print "\n" if date.saturday?
end
puts ''
