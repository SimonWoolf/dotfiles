#!/usr/bin/env ruby

files = `ls -a ~/dev/dotfiles`
          .split
          .reject {|f| f.length < 3}
          .reject {|f| f == '.git'}
          .select {|f| f[0] == '.'}

puts "symlinking #{files.join(', ')}"

files.each do |file|
  `ln -s ~/dev/dotfiles/#{file} ~`
end

`ln -s ~/dev/dotfiles/quicktile.cfg ~/.config/`

`mkdir ~/dev/vendor/quicktile`
`git clone git@github.com:SimonWoolf/quicktile.git ~/dev/vendor/quicktile/`

`sudo ln -s ~/dev/vendor/quicktile/quicktile.py /usr/local/bin/`

`mkdir -p ~/programs/bin/`

binfiles = `ls -a ~/dev/dotfiles/bin`
  .split
  .reject{|f| f[0] == '.'}

puts "symlinking #{binfiles.join(', ')}"

binfiles.each do |file|
  `ln -s ~/dev/dotfiles/bin/#{file} ~/programs/bin/`
  `chmod +x ~/programs/bin/#{file}`
end
