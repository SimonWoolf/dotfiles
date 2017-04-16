#!/usr/bin/env ruby

require 'socket'
def desktop?
  Socket.gethostname == 'simon-linuxdesktop'
end

HOME = `echo ~`.chomp

files = `ls -a ~/dev/dotfiles`
          .split
          .reject {|f| f.length < 3}
          .reject {|f| f == '.git'}
          .select {|f| f[0] == '.'}

puts "symlinking #{files.join(', ')}"

files.each do |file|
  `ln -fs ~/dev/dotfiles/#{file} ~`
end

`ln -fs ~/dev/dotfiles/quicktile.cfg ~/.config/`

`mkdir -p ~/.config/i3/`
`mkdir -p ~/.config/i3status/`
`ln -fs ~/dev/dotfiles/i3_config ~/.config/i3/config`
`ln -fs ~/dev/dotfiles/i3status_config ~/.config/i3status/config`

if !Dir.exist? "#{HOME}/dev/vendor/quicktile"
  `mkdir ~/dev/vendor/quicktile`
  `git clone git@github.com:SimonWoolf/quicktile.git ~/dev/vendor/quicktile/`
  `sudo ln -fs ~/dev/vendor/quicktile/quicktile.py /usr/local/bin/`
end


`mkdir -p ~/bin`

binfiles = `ls -a ~/dev/dotfiles/bin`
  .split
  .reject{|f| f[0] == '.'}

puts "symlinking #{binfiles.join(', ')}"

binfiles.each do |file|
  `ln -fs ~/dev/dotfiles/bin/#{file} ~/bin/`
  `chmod +x ~/bin/#{file}`
end

if desktop?
  `cat noedit i3_config_base i3_config_desktop > i3_config`
  `cat noedit i3status_config_base i3status_config_desktop > i3status_config`
else
  `cat noedit i3_config_base i3_config_laptop > i3_config`
  `cat noedit i3status_config_base i3status_config_laptop > i3status_config`
end
