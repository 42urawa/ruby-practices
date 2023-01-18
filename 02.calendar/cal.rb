require 'date'
require 'optparse'

options = ARGV.getopts("y:", "m:")
puts options

year  = (options["y"] ||= Date.today.year).to_i
month = (options["m"] ||= Date.today.month).to_i

date_beginning = Date.new(year, month, 1)
date_end       = Date.new(year, month, -1)

puts ""
puts "       #{month}月 #{year}"
puts " 日 月 火 水 木 金 土"
print " " * 3 * date_beginning.wday
date_end.day.times do
  print date_beginning.day.to_s.rjust(3)
  if date_beginning.strftime('%a') == "Sat"
    print "\n"
  end
  date_beginning += 1
end
puts ""
