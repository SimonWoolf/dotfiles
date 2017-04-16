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
  begin
    File.open("/tmp/tt_status", "r") do |f|
      JSON.parse(f.readline)
    end
  rescue EOFError, Errno::ENOENT
    []
  end
end

def keyboard_layout
  layout = `setxkbmap -query`.scan(/variant:\s+,?([a-z]+),?\n/)[0][0]
  [{ full_text: " KB #{layout} "}]
end

# Skip the first line which contains the version header.
puts readline()

# The second line contains the start of the infinite array.
puts readline()

# put an empty array so can assume every subsequent line should start with a comma
puts "[]"

loop do
  i3status = JSON.parse(readline().gsub(/^,/, ''))
  full_status = [
    tt_status,
    keyboard_layout,
    i3status
  ].reduce(:+).to_json
  puts "," + full_status
end
