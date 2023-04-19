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
  raw = ""
  begin
    File.open("/tmp/tt_status", "r") do |f|
      raw = f.readline
      JSON.parse(raw)
    end
  rescue EOFError, Errno::ENOENT
    []
  rescue JSON::ParserError
    STDERR.puts "Unparseable: '#{raw}'"
    []
  end
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
    i3status
  ].reduce(:+).to_json
  puts "," + full_status
end
