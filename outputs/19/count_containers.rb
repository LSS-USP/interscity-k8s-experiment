require 'json'
require 'colorize'
require 'csv'

if ARGV.count != 1
  puts "Provide the path of the input file -> ".red + "ruby count_containers.rb /path/to/file.txt".red.bold
  exit -1
end

file_name = ARGV.first


services = ["data-collector", "resource-catalog", "resource-discovery", "kong"]

contents = File.open(file_name){|f| f.read}
observations = contents.split(/=====/m)


new_one = false
output = []
output << services
observations.each do |obs|
  data = []
  services.each do |service|
    data << obs.scan(service).count
  end

  output << data
end

puts "Writing to count_containers.csv"
File.write("count_containers.csv", output.map(&:to_csv).join)
