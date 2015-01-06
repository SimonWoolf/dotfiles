# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export EDITOR=vim
export RACK_ENV="development"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
export HISTSIZE=
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

#if [[ $EUID -ne 0 ]]; then
  #PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;32m\]\$\[\e[m\] \[\e[m\]'
#else
  #PS1='\[\e[1;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;31m\]\$\[\e[m\] \[\e[m\]' 
#fi

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
# #    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#     ;;
# *)
#     ;;
# esac

#Make less (man pages) be colourful
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;37m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[0;36m")

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# git autocompletion
if [ -f ~/dev/dotfiles/git-completion.bash ] ; then
    source ~/dev/dotfiles/git-completion.bash
fi


# For moving a bunch of files, replacing one regex with another
#sedmv()
#{
#    for i in *; do mv "$i" "`echo $i |sed -e s/$1/$2/`"; done
#}
## Same as above, but you can specify a prefix for the files
#sedmvp()
#{
#    for i in $1*; do mv "$i" "`echo $i |sed -e s/$2/$3/`"; done
#}
## Check what sedmv would do
#sedchk()
#{
#    for i in *; do echo "$i" |sed -e "s/$1/$2/"; done
#}
## Check what sedmvp would do
#sedchkp()
#{
#    for i in $1*; do echo "$i" |sed -e "s/$2/$3/"; done
#}

#function netscan {
#    echo "192.168.0.0-?" 
#    read MAX
#    for ((i=0;i<=$MAX;i+=1)); do
#        ping -i 0.2 -c 1 192.168.0.$i | grep -B 1 "1 received"
#    done
#}

alias 'ps?'='ps aux | grep '
alias up="cd .."
alias back="cd -"
alias sudo="sudo "
alias showhardware="lshw"
alias df="df -h"
alias du="du -c -h"
#alias kernelver="uname -sr"
alias mountiso="mount -o loop"
#alias pwdreal="/bin/pwd"
#alias ewd='cd "`/bin/pwd`"' #Expand symlinks in working dir
alias mp="mousepad"
alias py="ipython3"
alias +='pushd .'
alias _='popd'
alias dusk='du -s -k -c * | sort -rn'  #Disk usage by directory
alias trash="mv -t ~/.local/share/Trash/files --backup=t"
alias nettop="sudo netstat -pant"
#alias battery='watch -n 0 "cat /proc/acpi/battery/BAT0/state; cat /proc/acpi/battery/BAT0/info; uptime"'
alias pysh="ipython -p sh"
#alias toman="--subnodes -o - 2> /dev/null | less"
alias vp="vim -R -"
alias iddqd="sudo -i"
alias locate="locate -i"
alias purge="sudo aptitude purge"
alias installed?="dpkg -l | grep "
alias hlinkto="find -type f -print0 | xargs -0 cp -l -t "
alias links="elinks"
#alias makemiddleclickwork="synclient TapButton2=2; synclient TapButton3=3"
alias fp="vlc /tmp/Flash*"
alias hdlist="sudo blkid"
alias offscreen='xvfb-run --server-args="-screen 0 1024x768x24"'
alias cmpd="ncmpc"
alias iplayer-dl-video="get_iplayer --flvstreamer /usr/bin/rtmpdump --modes=flashhd,flashvhigh1,flashvhigh,flashhigh --pid "
alias iplayer-dl-audio="get_iplayer --flvstreamer /usr/bin/rtmpdump --modes=flashaachigh,flashaac,flashaacstd, flashaacstd1,flashaudio,flashhigh,flashstd,flashnormal --pid "
#usage: flv2aac input output
alias flv2aac="ffmpeg -acodec copy -i "
#Usage: extractaudio INPUT -o OUTPUT
alias extractaudio="mencoder -ovc raw -oac mp3lame -lameopts preset=extreme -of rawaudio "
alias lll="ls -hlS"
export GREP_COLOR="1;33"
alias grep="grep -i --color=auto"
#alias diff="colordiff"
alias mkdir="mkdir -p -v"
alias ping="ping -c 4"
alias dul="du --max-depth=1"
alias h?="history | grep $1"
alias aux="amixer set 'Sigmatel 4-Speaker Stereo' toggle"
alias lf="find . | grep -i "
alias gr="git grep -i "

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias get="sudo apt-get install"
alias xo="xdg-open"
alias df="pydf"
alias acs="apt-cache search "
alias canhaz="sudo apt-get install"
alias aka="sudo apt-key adv --recv-keys "
alias as="aptitude search "
alias rem="sudo apt-get autoremove --purge "
alias show="apt-cache show"
alias agu="sudo apt-get update"
alias reencodeformediabox="ffmpeg -mbd rd -vtag xvid -flags +mv4+aic -trellis 2 -cmp 2 -subcmp 2 -g 300 -pass 2 -b 2000k -ab 192k -i "
#usage: reencodeasmpeg4 inputfile outputfile
alias updateipblock="sudo mv /var/cache/iplist/index.html\?list\=bt_level1 /var/cache/iplist/bt_level1 && sudo mv /var/cache/iplist/index.html\?list\=bt_level2 /var/cache/iplist/bt_level2"
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

# Programming aliases
alias rspec="rspec --color"
alias tree="tree -C"
alias rxpry="rvm use rbx-2.1.1 && pry"
alias gs="git status "
alias gpl="git pull "
alias gps="git push "
alias gc="git commit "
alias gca="git commit -a "
alias gcm="git commit -m "
alias gcam="git commit -am "
alias grv="git remote -v"
alias gd="git diff"
alias ga="git add --all "
alias g="git"
alias z='zeus'
alias cl="clear"
alias be="bundle exec "
alias killzeus="ps | grep zeus && ps | grep zeus | awk '{print $1}' | xargs kill -3"

alias hackerdump="find /var/log -type f -exec grep -I1 . {} \; | pv -q -L 1k "

#desktop-specific
if [[ "$HOSTNAME" == "simon-linuxdesktop" ]]; then
  alias tvoff="xrandr -s 0 && xmodmap ~/.Xmodmap && redshift -t 6500:4500 -l 51:0 &"
  alias tvon="xrandr -s 1 && xmodmap ~/.Xmodmap && killall redshift"
  # switches between nvidia-settings metamodes. In xorg.conf Screen:
    #Option         "metamodes" "DVI-I-2: nvidia-auto-select +1280+0, DVI-I-3: nvidia-auto-select +0+0, HDMI-0: NULL; DVI-I-2: nvidia-auto-select +1360+0, HDMI-0: nvidia-auto-select +0+0, DVI-I-3: NULL"
  #xmodmap ~/.Xmodmap &
fi


# OS-specific commands
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias ll='ls -l --color=auto'
  alias ls='ls --color=auto'
  export TERM="xterm-256color"
  # http://superuser.com/questions/52562/ssh-keychain-for-xfce
  export $(gnome-keyring-daemon --daemonize --start)
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias ll='ls -lG'
  alias ls='ls -G'
  alias ctags="`brew --prefix`/bin/ctags"
 elif [[ "$OSTYPE" == "cygwin" ]]; then
  export DISPLAY=localhost:0
# elif [[ "$OSTYPE" == "win32" ]]; then
#         # ...
# else# ...
fi

if [[ "$SESSION" == "xfce" ]]; then
  alias x="xmodmap ~/.Xmodmap"
fi

source ~/.git-pairing-prompt.sh
PROMPT_COMMAND=__git_pairing_prompt

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# secret keys
source ~/.apikeys

### Added by the Heroku Toolbelt
# also usr/local/bin for brew
export PATH="/usr/local/heroku/bin:/usr/local/bin:$PATH"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
