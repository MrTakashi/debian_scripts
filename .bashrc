###########################################################################################
# sudo ansible-playbook playbooks/debian/25_bashrc_vimrc_mc.yml
#
# old: wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/.bashrc >> ~/.bashrc
# old: runuser -l mk -c 'wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/.bashrc >> ~/.bashrc'

###### mk settings for history
# ~/.bashrc
 # don't put lines starting with space in the history
 # and don't put the same as the most recent command used
 HISTCONTROL=ignorespace
 # HISTCONTROL=ignorespace:ignoredups

 # append to the history file, don't overwrite it
 shopt -s histappend

 export HISTSIZE=10000
 export HISTFILESIZE=10000
 export HISTTIMEFORMAT="%h %d %H:%M:%S "
 export HISTIGNORE="ls:ll:l:history:h:gh:hg:w:htop:pwd"
 # ensure synchronization between bash memory and history file
 PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

###### mk settings for window
 # check the window size after each command and, if necessary,
 # update the values of LINES and COLUMNS.
 shopt -s checkwinsize

###### mk aliases

 ## ip info
 ipa() {
   curl -s "https://ifconfig.co/json?ip=$1" | jq 'del(.user_agent)'
 }

 ## myip
 alias myip='wget -qO- eth0.me && wget -qO- ifconfig.co'
#  alias myip='curl ifconfig.me ; echo'
 alias myip_='curl -s "https://ifconfig.co/json" | jq'
 alias myip_ip='curl -s "https://ifconfig.co/json" | jq -r .ip'

 ## history
 alias h='history'
 alias hg='history|grep'
 alias gh='history|grep'

 ## files listing
 export LS_OPTIONS='--color=auto'
 alias l='ls $LS_OPTIONS -l'
 alias ll='ls $LS_OPTIONS -lA'

 ## python virtual environment
 alias ve='python3 -m venv ./venv'
 alias va='source ./.venv/bin/activate'

 ## git
 alias gp='git pull'
 alias gs='git stash'

 ## tmux
 alias t="tmux a || tmux"

 tmx() {
  name="$1"
  if tmux list-sessions | grep -q "^${name}:"; then
    tmux attach -t "${name}"
  else
    tmux new-session -s "${name}"
  fi
}

 ## Colorize the grep command output for ease of use (good for log files)##
 alias grep='grep --color=auto'

#  alias f=far2l
#  alias yt=~/.local/bin/yt-dlp --proxy 59a9.l.time4vps.cloud:8888 --merge-output-format mp4 -f "bv*+ba/b" -S "res,br"

# Определение переменной с именем утилиты: bat или batcat
if [[ -e $(which batcat) ]]; then
    export bat="batcat"
    alias bat="batcat"
elif [[ -e $(which bat) ]]; then
    export bat="bat"
fi

# Конфигурация утилиты bat
if [[ -n $bat ]]; then
    export COLORTERM="truecolor"
    export BAT_THEME="Nord"  # Цветовая тема
    export MANPAGER="sh -c 'col -bx | $bat --language=man --style=plain'"  # Команда для просмотра man-страниц
    export MANROFFOPT="-c"  # Отключение перенос строк в man
    alias cat="$bat --style=plain --paging=never"
    alias less="$bat --paging=always"
    if [[ $SHELL == *zsh ]]; then # глобальный алиас --help если оболочка zsh
        alias -g -- --help='--help 2>&1 | $bat --language=help --style=plain'
    fi
    # Функции help имитирует ключ --help только с bat, пример: help ls
    help() { "$@" --help 2>&1 | $bat --language=help --style=plain; }
    # Функция tailf - аналог tail -f только с bat
    tailf() { tail -f "$@" | $bat --paging=never --language=log; }
    # Функция для просмотра изменений git diff с помощью bat
    batdiff() { git diff --name-only --relative --diff-filter=d | xargs $bat --diff; }
fi

# Настройка exa как замены ls
if [[ -e $(which exa) ]]; then
    if [[ -n "$DISPLAY" || $(tty) == /dev/pts* ]]; then # отображать иконки если псевдотерминал
        alias ls="exa --group --header --icons"
    else
        alias ls="exa --group --header"
    fi
    alias ll="ls --long"
    alias l="ls --long --all --header"
    alias lm="ls --long --all --sort=modified"
    alias lmm="ls -lbHigUmuSa --sort=modified --time-style=long-iso"
    alias lt="ls --tree"
    alias lr="ls --recurse"
    alias lg="ls --long --git --sort=modified"
fi

##### setup system default editor to vim
 export SYSTEMD_EDITOR=vim

##### mk settings for DynaConf
 export ENV_FOR_DYNACONF=production
