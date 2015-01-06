#!/usr/bin/env ruby

files = `ls -a ~/dev/dotfiles`
          .split
          .reject {|f| f.length < 3}
          .select {|f| f[0] == '.'}

puts "symlinking #{files.join(', ')}"

files.each do |file|
  `ln -s ~/dev/dotfiles/#{file} ~`
end

`cp ~/dev/dotfiles/com.googlecode.iterm2.plist ~/Library/Preferences/`
