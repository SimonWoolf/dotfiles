# bash git pairing prompt support
#     - based on git-prompt.sh @ https://github.com/git/git/tree/master/contrib/completion

# Not bash or zsh?
[ -n "$BASH_VERSION" -o -n "$ZSH_VERSION" ] || return 0

# Not an interactive shell?
[[ $- == *i* ]] || return 0

########################################################
# VTE functions to store the current directory to allow
# ctrl-shift-t to open a new terminal at the current dir
########################################################

__vte_urlencode() (
  # This is important to make sure string manipulation is handled
  # byte-by-byte.
  LC_ALL=C
  str="$1"
  while [ -n "$str" ]; do
    safe="${str%%[!a-zA-Z0-9/:_\.\-\!\'\(\)~]*}"
    printf "%s" "$safe"
    str="${str#"$safe"}"
    if [ -n "$str" ]; then
      printf "%%%02X" "'$str"
      str="${str#?}"
    fi
  done
)

__vte_osc7 () {
  printf "\033]7;file://%s%s\a" "${HOSTNAME:-}" "$(__vte_urlencode "${PWD}")"
}

__vte_prompt_command() {
  printf "\033]0;%s@%s:%s\007%s" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}" "$(__vte_osc7)"
}

__prompt ()
{
  local os=`uname 2>/dev/null`
  local device_symbol=""

  # if we're ssh'd into somewhere, remind ourselves
  if [ -n "$SSH_CLIENT" ]; then
    case "$HOSTNAME" in
      "simon-linuxdesktop")
        device_symbol="🖥️ "
        ;;
      "simon-thinkpad")
        device_symbol="💻 "
        ;;
      *)
        device_symbol="⚡ "
        ;;
    esac
  fi

  local d="$(pwd  2>/dev/null)"; # d = current working directory
  local tb="$(git symbolic-ref HEAD 2>/dev/null)";
  local b="${tb##refs/heads/}"; # b = branch
  local p="$(git config --get user.initials 2>/dev/null)"; # p = pair initials
  local s="$(git status --ignore-submodules --porcelain 2>/dev/null)"; # s = git status
  local r="$(git remote 2>/dev/null)/$b"; # r = remote
  local push_pull="$(git rev-list --left-right $r...HEAD 2>/dev/null)"; # push_pull = list of revisions
  local push_count=0
  local pull_count=0

  if [ -n "$push_pull" ]; then
	  local commit
	  for commit in $push_pull
	  do
		  case "$commit" in
		  "<"*) ((pull_count++)) ;;
		  ">"*) ((push_count++))  ;;
		  esac
	  done
  fi

  # COMPONENTS OF PROMPT
  local b_prompt=""         # branch portion
  local p_prompt=""         # pairing partner initials
  local ahead_r=""          # ahead of remote
  local behind_r=""         # behind remote
  local u_prompt=""         # untracked files
  local d_prompt="$d"       # directory portion

  case "$os" in
  # Color codes to use:
  # http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
  # http://mywiki.wooledge.org/BashFAQ/053
  # http://mywiki.wooledge.org/BashFAQ/037
  # Likewise, you could always alter your terminal preferences color scheme
  "MINGW"*|"CYGWIN"*)
    local untracked="*"
    local pull_arrow="-"
    local push_arrow="+"
    c_red () { printf '\e[0;31m'"$*"'\e[m'; }
    c_green () { printf '\e[0;32m'"$*"'\e[m'; }
    c_yellow () { printf '\e[0;33m'"$*"'\e[m'; }
    c_blue() { printf '\e[1;34m'"$*"'\e[m'; }
    c_clear () { printf '\e[m'"$*"; }
    if [[ "$s" == *\?\?* ]]; then
      u_prompt=" ${untracked}"
    fi
    if [ -n "$p" ]; then
      p_prompt="[${p}]"
    fi
    if [ "$push_count" -gt 0  ]; then
      ahead_r=" ${push_arrow}${push_count}"
    fi
    if [ "$pull_count" -gt 0  ]; then
      behind_r=" ${pull_arrow}${pull_count}"
    fi
    if [ -n "$b" ]; then
      b_prompt="[${b}${ahead_r}${behind_r}${u_prompt}]"
    fi
    PS1=""
    if [ -n "$s" ]; then
      printf "$(c_blue "%%s") $(c_red "%%s")$(c_yellow "%%s") $(c_green "$") $(c_clear)" "${d_prompt}" "${b_prompt}" "${p_prompt}"
    else
      printf "$(c_blue "%%s") $(c_green "%%s")$(c_yellow "%%s") $(c_green "$") $(c_clear)" "${d_prompt}" "${b_prompt}" "${p_prompt}"
    fi
    ;;
  "Darwin"*|"Linux"*|"GNU"*|"FreeBSD"*)
    # Set terminal title
    echo -ne "\033]0;${PWD}\007" | sed "s/\/mnt\/terra//;s/\/home\/simon/~/"

    if [[ $TERM == xterm-termite && "${VTE_VERSION:-0}" -ge 3405 ]]; then
      __vte_prompt_command
    fi

    local untracked="✶"
    local pull_arrow="▼ "
    local push_arrow="▲ "
    c_red=$(tput setaf 1);
    c_green=$(tput setaf 2);
    c_yellow=$(tput setaf 3);
    c_blue=$(tput setaf 4);
    c_clear=$(tput sgr0);
    bold=$(tput bold);
    normal=$(tput sgr0);
    if [[ "$s" == *\?\?* ]]; then
      u_prompt=" ${untracked}"
    fi
    if [ -n "$p" ]; then
      p_prompt="[${p}]"
    fi
    if [ "$push_count" -gt 0  ]; then
      ahead_r=" ${push_arrow}${push_count}"
    fi
    if [ "$pull_count" -gt 0  ]; then
      behind_r=" ${pull_arrow}${pull_count}"
    fi
    if [ -n "$b" ]; then
      b_prompt="[${b}${ahead_r}${behind_r}${u_prompt}]"
    fi
    if [ -n "$s" ]; then
      PS1="\[${bold}\]\[${c_blue}\]${device_symbol}\w \[${c_red}\]${b_prompt}\[${c_yellow}\]${p_prompt} \[${c_green}\]\$ \[${c_clear}\]\[${normal}\]"
    else
      PS1="\[${bold}\]\[${c_blue}\]${device_symbol}\w \[${c_green}\]${b_prompt}\[${c_yellow}\]${p_prompt} \[${c_green}\]\$ \[${c_clear}\]\[${normal}\]"
    fi
    ;;
  esac
}

PROMPT_COMMAND=__prompt
