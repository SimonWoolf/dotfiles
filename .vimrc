" NON-JANUS

" Set things that janus does by default
"set et "expand tabs
"set sts=2
"set tabstop=2
"set shiftwidth=2
"set nocompatible	" Use gVim defaults
"set history=1000
"set ignorecase
"set smartcase
"set number
"filetype on
"syntax enable
"
"let mapleader=","
"
"for file in split(glob('~/dev/dotfiles/vim-no-janus/*.vim'), '\n')
  "exe 'source' file
"endfor
"
"source ~/.vimrc.after

" JANUS

" Define paths
let g:janus_path = escape(expand("~/.vim/janus/vim"), ' ')
let g:janus_vim_path = escape(expand("~/.vim/janus/vim"), ' ')
let g:janus_custom_path = expand("~/.janus")

" Source janus's core
exe 'source ' . g:janus_vim_path . '/core/before/plugin/janus.vim'

" You should note that groups will be processed by Pathogen in reverse
" order they were added.
call janus#add_group("tools")
call janus#add_group("langs")
call janus#add_group("colors")

""
"" Customisations
""

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif


" Disable plugins prior to loading pathogen
exe 'source ' . g:janus_vim_path . '/core/plugins.vim'

""
"" Pathogen setup
""

" Load all groups, custom dir, and janus core
call janus#load_pathogen()

" .vimrc.after is loaded after the plugins have loaded
