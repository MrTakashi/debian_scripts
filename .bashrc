###########################################################################################
# sudo ansible-playbook playbooks/debian/25_bashrc_vimrc_mc.yml --vault-password-file /home/mk/vaultpass
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
 ## myip
 alias myip='wget -qO- eth0.me && wget -qO- ifconfig.co'
#  alias myip='curl ifconfig.me ; echo'
 alias myip_='curl -s 'https://ifconfig.co/json' | jq '
 alias myip_ip='curl -s 'https://ifconfig.co/json' | jq -r '.ip''

 ## history
 alias h='history'
 alias hg='history|grep'
 alias gh='history|grep'

 ## files listing
 export LS_OPTIONS='--color=auto'
 alias l='ls $LS_OPTIONS -l'
 alias ll='ls $LS_OPTIONS -lA'

 ## create and use Python virtual environment
 alias ve='python3 -m venv ./venv'
 alias va='source ./.venv/bin/activate'

 alias gp='git pull'
 alias gs='git stash'

 ## Colorize the grep command output for ease of use (good for log files)##
 alias grep='grep --color=auto'

#  alias f=far2l
#  alias yt=~/.local/bin/yt-dlp --proxy 59a9.l.time4vps.cloud:8888 --merge-output-format mp4 -f "bv*+ba/b" -S "res,br"

##### mk settings for DynaConf
 export ENV_FOR_DYNACONF=production
