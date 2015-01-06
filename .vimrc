" Comments: comment.vim Alt-C
" Indent > or < in visual mode

map <F3> ggVGg?

filetype plugin on

autocmd FileType python set omnifunc=pythoncomplete#Complete 
autocmd FileType python set autoindent
autocmd FileType python set smartindent
autocmd FileType python set cinwords=class,def,elif,else,except,finally,for,if,try,while  
"autocmd FileType python inoremap # X#
autocmd FileType tex set wrapmargin=5

set et "expand tabs
set sts=4 
set tabstop=4
set shiftwidth=4

set foldmethod=marker
" automatically save and restore folds
au BufWinLeave *.py mkview
au BufWinEnter *.py silent loadview
set foldlevel=0

inoremap <Nul> <C-x><C-o>

" :Pydoc :PydocSearch .vim/plugin

"Type :make or py syntax errors, :cp :cn to move between
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Execute selected python code with ctrl-h
"python << EOL
"import vim
"def EvaluateCurrentRange():
"    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
"EOL

map <C-h> :py EvaluateCurrentRange()

map <silent><A-Right> :tabnext<CR>
map <silent><A-Left> :tabprevious<CR>

autocmd FileType python highlight LeadingTab ctermbg=blue guibg=blue
"highlight LeadingSpace ctermbg=darkgreen guibg=darkgreen
"highlight EvilSpace ctermbg=darkred guibg=darkred
au Syntax * syn match LeadingTab /^\t\+/
au Syntax * syn match LeadingSpace /^\ \+/
au Syntax * syn match EvilSpace /\(^\t*\)\@<!\t\+/ " tabs not proceeded by tabs
au Syntax * syn match EvilSpace /[ \t]\+$/ " trailing space


" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

set nocompatible	" Use gVim defaults

set foldlevel=100

set history=1000

set ignorecase 
set smartcase

runtime macros/matchit.vim

filetype on

set nu

set guifont=Consolas\ 13

syntax enable
"filetype indent on

"make tabs and trailing spaces visible when requested: (\s)
"set listchars=tab:>-,trail:·,eol:$
"nmap <silent> <leader>s :set nolist!<CR>

"autocmd FileType python let g:SuperTabDefaultCompletionType = "<C-X><C-O>" 
"autocmd FileType tex let g:SuperTabDefaultCompletionType = "<C-X><C-P>" 
" default is C-X C-P: see .vim/plugin/supertab.vim

set cot+=menuone

" backspace in Visual mode deletes selection
vnoremap <BS> d

" Make CTRL-A do Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

hi Normal cterm=NONE ctermbg=Black ctermfg=Grey 
au InsertEnter * hi Normal ctermbg=DarkBlue ctermfg=Grey guibg=#DDDDFF
au InsertLeave * hi Normal ctermbg=Black ctermfg=Grey guibg=#FFFFFF



" set 'updatetime' to 15 seconds when in insert mode
au InsertEnter * let updaterestore=&updatetime | set updatetime=15000

" makes you haev to type `texa rather than `a for \alpha
let g:Tex_Leader = '`tex'
let g:Tex_Leader2 = ',tex'
