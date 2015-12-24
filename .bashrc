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
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

#Make less (man pages) be colourful
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;37m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[0;36m")

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# git autocompletion
if [ -f ~/dev/dotfiles/git-completion.bash ] ; then
    source ~/dev/dotfiles/git-completion.bash
fi

# fasd (hash will check if it exists)
#if hash fasd 2>/dev/null; then
  #eval "$(fasd --init auto)"
#fi

alias 'ps?'='ps aux | grep '
alias sudo="sudo "
alias df="df -h"
alias du="du -c -h"
alias mountiso="mount -o loop"
alias py="ipython3"
alias dusk='du -s -k -c * | sort -rn'  #Disk usage by directory
alias trash="mv -t ~/.local/share/Trash/files --backup=t"
alias nettop="sudo netstat -pant"
alias pysh="ipython -p sh"
alias vp="vim -R -"
alias iddqd="sudo -i"
alias locate="locate -i"
alias installed?="dpkg -l | grep "
alias hlinkto="find -type f -print0 | xargs -0 cp -l -t "
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
alias mkdir="mkdir -p -v"
alias ping="ping -c 4"
alias dul="du --max-depth=1"
alias h?="history | grep $1"
alias lf="find . | grep -i "
alias gr="git grep -i "
# merge/uniqify nonadjacent
alias stripduplines="perl -ne '$H{$_}++ or print'"
# Stops it erroring on startup on laptop
alias gpa="gpa --disable-x509"

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

function settitle() {
  PROMPT_COMMAND="echo -ne '\033]0;$1\007'"
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias get="sudo apt-get install"
alias xo="xdg-open"
alias df="pydf"
alias acs="apt-cache search "
alias aka="sudo apt-key adv --recv-keys "
alias rem="sudo apt-get autoremove --purge "
alias show="apt-cache show"
alias agu="sudo apt-get update"
#usage: reencodeformediabox inputfile outputfile
alias reencodeformediabox="ffmpeg -mbd rd -vtag xvid -flags +mv4+aic -trellis 2 -cmp 2 -subcmp 2 -g 300 -pass 2 -b 2000k -ab 192k -i "
alias updateipblock="sudo mv /var/cache/iplist/index.html\?list\=bt_level1 /var/cache/iplist/bt_level1 && sudo mv /var/cache/iplist/index.html\?list\=bt_level2 /var/cache/iplist/bt_level2"
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

# Programming aliases
alias hpg="history | grep"
#alias iex="iex --sname dev "
alias rspec="rspec --color"
alias tree="tree -C"
alias rxpry="rvm use rbx-2.1.1 && pry"
alias gs="git status "
alias gc="git commit "
alias gca="git commit -a "
alias gcm="git commit -m "
alias gcam="git commit -am "
alias grv="git remote -v"
alias gd="git diff"
alias ga="git add --all "
alias gps="git push"
alias gpl="git pull"
alias g="git"
alias z='zeus'
alias cl="clear"
alias be="bundle exec "
alias killzeus="ps | grep zeus && ps | grep zeus | awk '{print $1}' | xargs kill -3"

alias hackerdump="find /var/log -type f -exec grep -I1 . {} \; | pv -q -L 1k "

#desktop-specific
if [[ "$HOSTNAME" == "simon-linuxdesktop" ]]; then
  alias tvoff="xrandr -s 0 && redshift -t 6500:4500 -l 51:0 &"
  alias tvon="xrandr -s 1 && killall redshift"
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
fi

if [[ "$SESSION" == "xubuntu" ]]; then
  alias xl="xmodmap ~/.XmodmapForLaptopKeyboard"
  alias xte="xmodmap ~/.XmodmapForTrulyErgonomic"
fi

source ~/.git-pairing-prompt.sh
PROMPT_COMMAND=__git_pairing_prompt

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# secret keys
[ -f ~/.apikeys ] && source ~/.apikeys

# heroku; CUDA paths
# also usr/local/bin for random things
# Also RVM for scripting (after system-wide things)
export PATH="/usr/local/cuda-7.0/bin:/usr/local/heroku/bin:/usr/local/bin:$PATH:$HOME/.rvm/bin"
export LD_LIBRARY_PATH=/usr/local/cuda-7.0/lib:$LD_LIBRARY_PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="/home/simon/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Torch -- needed for waifu2x image resizer
# . /mnt/terra/home/simon/programs/torch/install/bin/torch-activate
