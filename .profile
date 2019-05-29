# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
else
  # at least set the path so sh can find executables
  export ARDUINO_PATH=/usr/local/arduino
  export PATH="/usr/local/heroku/bin:$PATH:$HOME/bin:$HOME/dev/dotfiles/bin:$HOME/.cargo/bin"
fi

# on 18.04, system would logout on resume due to
# https://askubuntu.com/questions/1038649/automatic-logout-when-resuming-from-suspend-on-xubuntu-18-04
# workaround was to remove at-spi2-core, this stops gnome apps complaining at that
export NO_AT_BRIDGE=1

export LANGUAGE="en_GB:en"
export LC_MESSAGES="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
