require 'nokogiri'

def do_time_test(html, n)
  start = Time.now
  n.times do
    tree = Nokogiri::HTML(html)
    tree.root
  end
  stop = Time.now

  puts "#{stop - start} s"
end

do_time_test File.read(ARGV[0]), ARGV[1].to_i
