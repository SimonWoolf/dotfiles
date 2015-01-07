" NON-JANUS USE ONLY

" Set things that janus does by default
set et "expand tabs
set sts=2
set tabstop=2
set shiftwidth=2
set nocompatible	" Use gVim defaults
set history=1000
set ignorecase
set smartcase
set number
filetype on
syntax enable

let mapleader=","

for file in split(glob('~/dev/dotfiles/vim-no-janus/*.vim'), '\n')
  exe 'source' file
endfor

source ~/.vimrc.after
