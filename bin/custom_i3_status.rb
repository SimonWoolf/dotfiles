#!/usr/bin/env ruby

# Ported from Valentin Haenel <valentin.haenel@gmx.de> 's Python
# implementation, https://github.com/i3/i3status/blob/master/contrib/wrapper.py

require 'json'
STDOUT.sync = true

def readline
  line = STDIN.gets.chomp
  # i3status sends EOF, or an empty line
  if line.nil? || line.empty?
    exit
  end
  line
end

def tt_status
  File.open("/tmp/tt_status", "r") do |f|
    result = f.readline
    f.close()
    result
  end
end

# Skip the first line which contains the version header.
puts readline()

# The second line contains the start of the infinite array.
puts readline()

# put an empty array so can assume every subsequent line should start with a comma
puts "[]"

loop do
  i3status = readline()
  i3status.gsub!(/^,/, '')
  full_status = (JSON.parse(tt_status) + JSON.parse(i3status))
  full_status = full_status.to_json
  puts "," + full_status
end
