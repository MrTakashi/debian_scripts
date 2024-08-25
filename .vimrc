" ###########################################################################################
" sudo ansible-playbook playbooks/debian/25_bashrc_vimrc_mc.yml --vault-password-file /home/mk/vaultpass
"
" old: wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/.vimrc > ~/.vimrc
" old: runuser -l mk -c 'wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/.vimrc > ~/.vimrc'
" old: runuser -l mk -c 'wget -qO - https://raw.githubusercontent.com/MrTakashi/debian_scripts/main/.vimrc > ~/.vimrc'

" use extended feature of vim (no compatible with vi)
set nocompatible

" specify character encoding
set encoding=utf-8

" specify file encoding
" to specify multiple entries, write them with comma separated
set fileencodings=utf-8

" take backup
" opposite is [ set nobackup ]
" set backup

" specify backup directory
set backupdir=~/backup

" number of search histories
set history=50

" ignore Case
set ignorecase

" distinct Capital if you mix it in search words
set smartcase

" highlights matched words
" opposite is [ set nohlsearch ]
set hlsearch

" use incremental search (like search in modern browsers)
" opposite is [ set noincsearch ]
set incsearch

" highlights parentheses
set showmatch

" show color display
" opposite is [ syntax off ]
syntax on

" nowrap lines
set nowrap

" Always show current position
set ruler

" Enable mouse copy/paste in terminal (do not go to the visual mode)
set mouse=r

" enable auto indent
" opposite is [ noautoindent ]
set autoindent

" show line number
set number
" opposite is [ set nonumber or set number!]

" visualize break ( $ ) or tab ( ^I )
" set list

" not insert LF at the end of file
" set binary noeol

" *** Based on
" https://www.server-world.info/en/note?os=Debian_12&p=initial_conf&f=7
