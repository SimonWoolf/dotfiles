"""""""""""""""""
" global defaults
"""""""""""""""""

set et "expand tabs
set tabstop=2
set shiftwidth=2
set nocompatible " Use gVim defaults
set history=2000
set ignorecase
set smartcase
set number
set hlsearch
set incsearch
set cindent
" for vim-lightline
set laststatus=2
set noshowmode

filetype on
filetype plugin on
filetype plugin indent on
syntax enable

let mapleader=","

"vim force redraw on switching tabs to fix buffer corruption issues
set ttyfast
au TabEnter * :redraw!

if has("gui_running")
  " no themed tabs -- avoids issues when running mixed-dpi multi-monitors
  set guioptions-=e

  if has("gui_gtk")
    set guifont=Meslo\ LG\ S\ for\ Powerline\ 10
  endif
endif

colorscheme lucius
set background=light

"tabline colours
:hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
:hi TabLine ctermfg=Blue ctermbg=Yellow
:hi TabLineSel ctermfg=Red ctermbg=Yellow

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

let g:EasyMotion_leader_key = '<Leader>'

set ssop-=options

"http://usevim.com/2012/10/19/vim101-set-hidden/
set hidden

" http://stackoverflow.com/questions/9511253/how-to-effectively-use-vim-wildmenu
set wildmenu
set wildmode=longest:full,full
set history=2000

nnoremap ; :
vnoremap ; :

noremap <C-h> <C-w>h
noremap <C-Left> <C-w>h
noremap <C-j> <C-w>j
noremap <C-Down> <C-w>j
noremap <C-k> <C-w>k
noremap <C-Up> <C-w>k
noremap <C-l> <C-w>l
noremap <C-Right> <C-w>l

nmap <silent> ,/ :nohlsearch<CR>

" makes j & k work properly with wrapped text
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" Use ,tab for omnicompletion in normal mode
nnoremap <leader><tab> a<C-x><C-o>
" show method signatures in the autocomplete menu
let g:tsuquyomi_completion_detail = 1
" integrate tsuquyomi (typescript) with syntastic
" autocmd Filetype typescript let g:tsuquyomi_disable_quickfix = 1
" autocmd Filetype typescript let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
autocmd Filetype typescript syntax sync fromstart

" disable typescript-vim's custom indenter which is glacially slow on large
" files
" -- temp reenabled because the default enter is giving stupid results..?
" let g:typescript_indent_disable = 1


if has('nvim')
  set title titlestring=%t
  let g:instant_log=1
  set mouse=nv
endif

" get tooltip window under mouse cursor
if !has('nvim')
  set ballooneval
endif

"tsuquyomi
if !has('nvim')
  autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
endif
autocmd FileType typescript nmap <buffer> <Leader>ts : <C-u>echo tsuquyomi#hint()<CR>
",, to show type definition of thing under cursor in status bar
autocmd FileType typescript nnoremap <buffer> <Leader><Leader> : <C-u>echo tsuquyomi#hint()<CR>
"ctrl-[ to go to where the type of a thing under cursor is defined, ctrl-] to
"go to where the thing is defined (exists by default)
autocmd FileType typescript nmap <buffer> <C-[> : <C-u>TsuquyomiTypeDefinition<CR>
" stop it opening new window with completion options
autocmd FileType typescript setlocal completeopt=menu

" Some helpers to open files
" http://vimcasts.org/e/14
nmap <leader>ew :e <C-R>=expand('%:h').'/'<cr>
nmap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
nmap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
nmap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>

" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"makes ,uc do upcase (it's in my muscle memory now, though
",u does it after a second pause
nmap <leader>uc mQviwU`Q

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set wrap

" ripper-tags -- ruby indexer (gem) for ctags. lets you do ctrl-]
" on an object to go to its definition, or :tag, or :CtrlPTag
autocmd Filetype ruby command! RubyTagsReload execute  "!ripper-tags -R --exclude='*.js' --exclude='*.sql' . 2> /dev/null && echo 'Ripper tags reloaded'"

" go equivalent
autocmd Filetype go command! GoTagsReload execute  "find . | grep '.go$' | xargs gotags > tags && echo 'Gotags reloaded'"

command! CTagsReload execute "!ctags -R . && echo 'ctags reloaded'"

let g:ctrlp_custom_ignore = {
   \ 'dir':  '\v[\/]\.(git|hg|svn)|\v[\/](node_modules|bower_components)|tmp|dist|spec/integration/vcr_cassettes|public/assets|ebin$',
   \ 'file': '\v\.(exe|so|dll)$'
   \ }
map <C-t> :CtrlPTag<cr>

map <C-b> :CtrlPBuffer<CR>

set foldmethod=manual
set nofoldenable


autocmd Filetype typescript,javascript call FoldLoggerCalls()
function FoldLoggerCalls()
  setlocal foldmethod=marker
  setlocal foldmarker=Logger.log,);
  setlocal foldenable
  setlocal foldminlines=2
  highlight Folded guibg=background guifg=DarkGrey
  function! LoggerFoldText()
    return '    Logger (folded)'
  endfunction
  set foldtext=LoggerFoldText()
endfunction

" Syntax method can be slooow on some files.
" So do it once on initial buffer load,
" then just switch to manual while editing.
"autocmd BufReadPost,FileReadPost * setlocal foldmethod=manual

" vim clipbloard is system clipboard!
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" set trailing whitespace to grey not red
highlight ExtraWhitespace ctermbg=grey guibg=grey

" Open quickfix window after using Ggrep
autocmd QuickFixCmdPost *grep* cwindow

let g:ctrlp_switch_buffer=0

" Use alt+left/right or h/l to switch tabs
noremap <silent><A-Right> :tabnext<CR>
noremap <silent><A-Left> :tabprevious<CR>
noremap <silent><A-l> :tabnext<CR>
noremap <silent><A-h> :tabprevious<CR>

noremap <C-S-PageUp> :tabmove -1<CR>
noremap <C-S-PageDown> :tabmove +1<CR>

"switching between buffers
noremap <A-PageUp> :bnext<CR>
noremap <A-PageDown> :bprev<CR>
" close current buffer
noremap <C-q> :bd<CR>

" Show tabs
set list listchars=tab:»\ ,trail:·,extends:>,precedes:<

" relies on https://github.com/terryma/vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" search for things using /something
" hit caw, replace first match, and hit <Esc>
" hit n.n.n.n.n. reviewing and replacing all matches

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Persistent undo!
set undofile
set backup
" neovim undofiles are incompatible with normal vim
if has('nvim')
  set undodir=~/.vim/nundodir
  set backupdir=~/.vim/_nbackup
  set directory=~/.vim/_ntemp
else
  set undodir=~/.vim/undodir
  set backupdir=~/.vim/_backup
  set directory=~/.vim/_temp
endif
set undolevels=1000 " How many undos
set undoreload=10000 " number of lines to save for undo

set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Stop windows scrolling together
set nocursorbind
set noscrollbind

" insert date with ,d time with ,t
nnoremap <leader>d "=strftime("%a %d %b %Y")<CR>P
nnoremap <leader>time "=strftime("%T")<CR>P

" vim-latexsuite tweaks
" =====================

let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_ViewRule_pdf = 'evince'
let g:Imap_FreezeImap=1
autocmd Filetype tex setlocal nofoldenable

" use xelatex
let g:Tex_CompileRule_pdf = 'xelatex -aux-directory=/tmp/xelatex -interaction=nonstopmode $*'

" makes you have to type `texa rather than `a for \alpha
let g:Tex_Leader = '`tex'
let g:Tex_Leader2 = ',tex'

" grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Per-project vimrc
if filereadable("._vimrc")
    source ._vimrc
endif

function! ElmFormat()
  let l:curw = {}
  try
    mkview!
  catch
    let l:curw = winsaveview()
  endtry

  call elm#Format()
  " custom formattings. 0777 makes it process the whole file at once, to allow
  " replacements to span multiple lines
  undojoin | silent %!perl -0777 -p -e "s/->\n\s+/-> /g,s/=\n\s+/= /g,s/( *)(.*) let\n/\1\2\n\1    let\n/g,s/\n\n( *)else/\n\1else/g,s/\n\n\n/\n\n/g"

  " restore our cursor/windows positions, folds, etc..
  if empty(l:curw)
    silent! loadview
  else
    call winrestview(l:curw)
  endif
endfunction


" Disable default Elm code formatting on save, use custom
let g:elm_format_autosave = 0
augroup elmFormat
  autocmd!
  autocmd BufWritePre *.elm call ElmFormat()
  autocmd BufWritePost *.elm call elm#util#EchoStored()
augroup END

set tabstop=2

" User EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Turn off json concealing
let g:vim_json_syntax_conceal=0

" supertab
set omnifunc=syntaxcomplete#Complete
" the problem with 'context' is it uses omnifunc for code completion, but
" tsuquyomi does not work properly with omnifunc chaining as it uses
" complete_add, so you then get no results when tsuquyomi can't find anything.
" So just use ctrl-p and use omnicompletion explicitly when desired (c-x c-o)
let g:SuperTabDefaultCompletionType = '<c-p>'

noremap <silent><A-Left> :tabprevious<CR>

" fugitive
nnoremap <leader>gb :Git blame<CR>

" upper/lower word
nmap <leader>u mQviwU`Q
nmap <leader>l mQviwu`Q

" upper/lower first char of word
nmap <leader>U mQgewvU`Q
nmap <leader>L mQgewvu`Q

" Underline the current line with '='
nmap <silent> <leader>ul :t.<CR>Vr=

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" wrapping
autocmd FileType typescript setlocal textwidth=90
autocmd FileType javascript setlocal textwidth=90

" ale linters
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tsserver'],
\   'go': ['govet'],
\}

let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0

"go to next or previous error in quickfix list
"or open and close it
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
nnoremap <C-a> :cprev<CR>
nnoremap <C-s> :cnext<CR>
nnoremap <C-f> :QFix<CR>


"""""""""""""""""""""""""""""""""""
" specific plugin pre-configuration
"""""""""""""""""""""""""""""""""""

let g:airline_powerline_fonts = 1
let g:airline_section_y = ''
let g:airline_section_z = ''
let g:airline_inactive_collapse = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:lightline = { 'colorscheme': 'wombat', 'enable': { 'tabline': 0 } }

"let g:syntastic_ruby_checkers=['mri']
"let g:syntastic_ruby_exec = "$HOME/.rvm/rubies/ruby-2.1.0/bin/ruby"

let g:ctrlp_max_files=0
let g:ctrlp_max_depth=30

" vim-go
" stop vim-go hijacking shift-k
let g:go_doc_keywordprg_enabled = 0
" stop vim-go hijacking ctrl-] (can always use gd for godef)
let g:go_def_mapping_enabled = 0
nnoremap <leader>gob :GoBuild<CR>
nnoremap <leader>god :GoDef<CR>
nnoremap <leader>goh :GoDoc<CR><CR>
" nnoremap <leader>got :GoDefType<CR>
nnoremap <leader>gor :GoRun<CR>
nnoremap <leader>got :GoTest<CR>
" type of current var in status bar
let g:go_auto_type_info = 1


let g:instant_markdown_autostart = 0

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
