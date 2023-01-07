# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export EDITOR=vim
export BROWSER=firefox
export AWS_PROFILE=ably
export AWS_REGION=eu-west-2 # default to london when it doesn't matter

export GOOGLE_APPLICATION_CREDENTIALS="/home/simon/google-credentials.json"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# interprets a plain directory as an instruction to cd into it
shopt -s autocd
# fix spelling errors
shopt -s cdspell
shopt -s dirspell

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
alias vp="nvim -R -"
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
# merge/uniqify nonadjacent
alias stripduplines="perl -ne 'print if ! $a{$_}++' "
# Stops it erroring on startup on laptop
alias gpa="gpa --disable-x509"
alias hpg="history | grep -i "
# pulp, purs, bower required for insect
alias install-node-globals="npm install -g grunt nodeunit insect diff-so-fancy mqtt-cli"
alias cal="ncal -bM"

# Point-free style! neat
hist() {
  sort | uniq -c | sort -n -r
}

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

alias get="sudo apt install"
alias xo="xdg-open"
alias df="pydf |grep -v snap"
alias acs="apt-cache search "
alias as="apt search "
alias aka="sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com --recv-keys "
alias rem="sudo apt autoremove --purge "
alias show="apt-cache show"
alias agu="sudo apt update"
alias au="sudo apt update"
alias adu="sudo apt dist-upgrade"
#usage: reencodeformediabox inputfile outputfile
alias reencodeformediabox="ffmpeg -mbd rd -vtag xvid -flags +mv4+aic -trellis 2 -cmp 2 -subcmp 2 -g 300 -pass 2 -b 2000k -ab 192k -i "
alias updateipblock="sudo mv /var/cache/iplist/index.html\?list\=bt_level1 /var/cache/iplist/bt_level1 && sudo mv /var/cache/iplist/index.html\?list\=bt_level2 /var/cache/iplist/bt_level2"
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

# Programming aliases
alias hpg="history | grep"
#alias iex="iex --sname dev "
alias rspec="rspec --color"
alias tree="tree -C"
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
# oddly aliasing to `git gr` does not work as expected when in a subdirectory
# of the repo, it searches the whole repo - the git alias is messing with
# however the cwd is passed to git-grep or something?
alias gr="git grep -i -E "
alias ga-p="git add -p"
alias glg="git lg"
alias g="git"
alias z='zeus'
alias cl="clear"
alias be="bundle exec "
alias killzeus="ps | grep zeus && ps | grep zeus | awk '{print $1}' | xargs kill -3"
alias j=" jq '.'"
alias jsonfmt="python -m json.tool"
alias arst="asdf"
alias hackerdump="find /var/log -type f -exec grep -I1 . {} \; | pv -q -L 1k "
# if not installed: npm install -g insect
alias calc="insect"
alias clipcopy="xclip -selection clipboard "
alias ae="ably-env "
alias cd..="cd .."
alias cd.="cd ."
alias ipa="ip -color -br a"
alias nv="nvim-qt"
alias v="nvim-qt"

alias playding="mplayer /home/simon/dev/dotfiles/pomodoro-finish.wav -speed 5 -volume 50"
alias playgong="mplayer /home/simon/dev/dotfiles/pomodoro-finish.wav -volume 50"

# google drive aliases
alias dpl="drive pull ."
alias dps="drive push ."
alias dmkdir="drive new -folder "
alias drm="drive delete "
alias d="drive "
alias mostest="less"

alias sony-connect="bluetoothctl connect 94:DB:56:A3:35:9D"
alias sony-disconnect="bluetoothctl disconnect 94:DB:56:A3:35:9D"
alias sony-hqaudio="pactl set-card-profile bluez_card.94_DB_56_A3_35_9D a2dp_sink"
alias sony-headset="pactl set-card-profile bluez_card.94_DB_56_A3_35_9D handsfree_head_unit"
alias aftershoks-connect="bluetoothctl connect 20:74:cf:3f:73:25"
alias aftershoks-disconnect="bluetoothctl disconnect 20:74:cf:3f:73:25"
alias aftershoks-hqaudio="pactl set-card-profile bluez_card.20_74_CF_3F_73_25 a2dp_sink"
alias aftershoks-headset="pactl set-card-profile bluez_card.20_74_CF_3F_73_25 handsfree_head_unit"

#desktop-specific
if [[ "$HOSTNAME" == "simon-linuxdesktop" ]]; then
  alias tvoff="xrandr -s 0 && redshift -t 6500:4500 -l 51:0 &"
  alias tvon="xrandr -s 1 && killall redshift"
  # switches between nvidia-settings metamodes. In xorg.conf Screen:
    #Option         "metamodes" "DVI-I-2: nvidia-auto-select +1280+0, DVI-I-3: nvidia-auto-select +0+0, HDMI-0: NULL; DVI-I-2: nvidia-auto-select +1360+0, HDMI-0: nvidia-auto-select +0+0, DVI-I-3: NULL"
  #xmodmap ~/.Xmodmap &
fi

function crtime() {
  sudo debugfs -R "stat <`stat -c %i ${@}`>" `\df --output=source ${@} | tail -1` | grep crtime
}

function ably-env() {
  (cd /home/simon/ably/infrastructure ; ./bin/ably-env ${@} )
}

# OS-specific commands
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias ll='ls -lh --color=auto'
  alias ls='ls --color=auto'
  #export TERM="xterm-256color" -- useful for xfce4-terminal, but breaks things on termite
  # http://superuser.com/questions/52562/ssh-keychain-for-xfce
  # export $(gnome-keyring-daemon --daemonize --start)
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

source ~/.prompt.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# secret keys
[ -f ~/.apikeys ] && source ~/.apikeys

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# heroku, CUDA, my stuff paths
# note: .local/bin is prepended so that local stack & pip take precendence over systemwide one (which is used by wireshark for some reason)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/cuda-7.0/bin:/usr/local/heroku/bin:$PATH:$HOME/bin:$HOME/dev/dotfiles/bin:$HOME/.poetry/bin:$(go env GOPATH)/bin"
export LD_LIBRARY_PATH=/usr/local/cuda-7.0/lib:$LD_LIBRARY_PATH
export ARDUINO_PATH=/usr/local/arduino


if [ -f $HOME/programs/alacritty/extra/completions/alacritty.bash ] ; then
    source $HOME/programs/alacritty/extra/completions/alacritty.bash
fi

export ALLOW_BASIC_AUTH_WITHOUT_TLS=true # easier experimentation with wscat without tls
# export NODE_TLS_REJECT_UNAUTHORIZED=0 # make ably-js tests work with self-signed certs
export NODE_EXTRA_CA_CERTS=/home/simon/ably/realtime/common/conf/certificates/dummy-rootCA.crt
export CURL_CA_BUNDLE=/home/simon/ably/realtime/common/conf/certificates/dummy-rootCA.crt
export ADMIN_UPDATE_LOG_LEVEL=micro
export SIEGE_MODE_POLICY=off
export ABLY_ENV_OPEN_SSO_URL=true
export ABLY_SSH_POST_LOGIN_COMMAND="(curl --silent https://raw.githubusercontent.com/thestinger/termite/master/termite.terminfo -o /tmp/termite.terminfo && tic -x /tmp/termite.terminfo &) && cd /var/log/ably"
export NO_REGISTRY_CACHE=true

export ERL_AFLAGS="-kernel shell_history enabled"

# Torch -- needed for waifu2x image resizer
# . /mnt/terra/home/simon/programs/torch/install/bin/torch-activate

if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
fi
TITLE="\[\e]2;$@\a\]"
PS1=${ORIG}${TITLE}

function datemillis() {
  date -u -d @`echo $1 | cut -c1-10`
}
alias dateaccur="date +"%H:%M:%S.%3N""

# simple calculator. run as
# = '5*5'
=() {
    local IFS=' '
    local calc="$*"
    # Uncomment the below for (p → +) and (x → *)
    #calc="${calc//p/+}"
    #calc="${calc//x/*}"
    printf '%s\n quit' "$calc" | gcalccmd 2>/dev/null | sed 's:^> ::g'
}

function mdrender() {
    pandoc "$1"  > /tmp/pandoc.html; firefox /tmp/pandoc.html
}

# added by travis gem
[ -f /home/simon/.travis/travis.sh ] && source /home/simon/.travis/travis.sh

# Allow firefox to use wayland if it's running under that, or it takes like 30s to start
MOZ_ENABLE_WAYLAND=1

# export CC="ccache clang"
# export CXX="ccache clang++"
# export CC="ccache gcc"
# export CXX="ccache g++"
export CC="gcc"
export CXX="g++"

eval $(keychain --eval --dir $HOME/.config/keychain --quiet --noask --agents gpg,ssh id_rsa id_ed)
ssh-add ~/.ssh/id_ed 2>/dev/null
