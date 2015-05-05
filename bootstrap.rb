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

`git clone git@github.com:ssokolow/quicktile.git ~/dev/vendor`

`sudo ln -s ~/dev/vendor/quicktile/quicktile.py /usr/local/bin/`
