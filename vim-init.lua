vim.opt.runtimepath:prepend("~/.vim")

vim.opt.packpath = '/home/simon/dev/dotfiles/vim_plugins/'

-- core vim settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.history = 10000
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.cindent = true
vim.opt.laststatus = 2
vim.opt.showmode = false

vim.g.mapleader = ","

vim.opt.undofile = true
vim.opt.backup = true
vim.opt.grepprg = 'grep -nH $*'
vim.opt.wrap = true
vim.opt.title = true
vim.opt.titlestring = '%t'
vim.opt.mouse = 'nv'
vim.opt.list = true
vim.opt.listchars = {tab = '» ', trail = '·', extends = '>', precedes = '<'}

vim.opt.undodir = vim.fn.expand('~/.vim/nundodir')
vim.opt.backupdir = vim.fn.expand('~/.vim/_nbackup')
vim.opt.directory = vim.fn.expand('~/.vim/_ntemp')

vim.opt.clipboard = 'unnamedplus'

vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.writebackup = true
vim.opt.backupcopy = 'yes'

vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

vim.opt.hidden = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.shortmess:remove('options')
vim.g.instant_log = 1

vim.keymap.set('n', '<C-a>', ':lprev<CR>')
vim.keymap.set('n', '<C-s>', ':lnext<CR>')
vim.keymap.set('n', '<C-f>', ':LFix<CR>')

vim.keymap.set('n', '<C-x>', ':ALENextWrap<CR>')
vim.keymap.set('n', '<C-z>', ':ALEPrevWrap<CR>')

if vim.fn.has('gui_running') == 1 then
  vim.opt.guioptions:remove('e')
  if vim.fn.has('gui_gtk') == 1 then
    vim.opt.guifont = 'Meslo LG S for Powerline 10'
  end
end

vim.cmd('colorscheme lucius')
vim.opt.background = 'light'

-- core movement/editing maps
vim.keymap.set('n', '<CR>', ':noh<CR><CR>')
vim.keymap.set({'n', 'v'}, ';', ':')

-- window movement
local directions = {
  h = 'h', Left = 'h',
  j = 'j', Down = 'j',
  k = 'k', Up = 'k',
  l = 'l', Right = 'l'
}
for key, dir in pairs(directions) do
  vim.keymap.set('n', '<C-'..key..'>', '<C-w>'..dir)
end

-- movement with wrapped lines
vim.keymap.set({'n', 'v'}, 'j', 'gj')
vim.keymap.set({'n', 'v'}, 'k', 'gk')

-- tab stuff
vim.keymap.set('n', '<A-Right>', ':tabnext<CR>', {silent = true})
vim.keymap.set('n', '<A-Left>', ':tabprevious<CR>', {silent = true})
vim.keymap.set('n', '<A-l>', ':tabnext<CR>', {silent = true})
vim.keymap.set('n', '<A-h>', ':tabprevious<CR>', {silent = true})
vim.keymap.set('n', '<C-S-PageUp>', ':tabmove -1<CR>')
vim.keymap.set('n', '<C-S-PageDown>', ':tabmove +1<CR>')

-- buffer management
vim.keymap.set('n', '<A-PageUp>', ':bnext<CR>')
vim.keymap.set('n', '<A-PageDown>', ':bprev<CR>')
vim.keymap.set('n', '<C-q>', ':bd<CR>')

-- leader mappings
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', {silent = true})
vim.keymap.set('n', '<leader><tab>', 'a<C-x><C-o>')
vim.keymap.set('n', '<leader>d', '"=strftime("%a %d %b %Y")<CR>P')
vim.keymap.set('n', '<leader>time', '"=strftime("%T")<CR>P')

-- file opening helpers
vim.keymap.set('n', '<leader>ew', ':e <C-R>=expand("%:h")."/"<CR>')
vim.keymap.set('n', '<leader>es', ':sp <C-R>=expand("%:h")."/"<CR>')
vim.keymap.set('n', '<leader>ev', ':vsp <C-R>=expand("%:h")."/"<CR>')
vim.keymap.set('n', '<leader>et', ':tabe <C-R>=expand("%:h")."/"<CR>')

-- paste without yanking
function RestoreRegister()
  vim.fn.setreg('"', vim.b.restore_reg)
  return ''
end

function Repl()
  vim.b.restore_reg = vim.fn.getreg('"')
  return "p@=v:lua.RestoreRegister()<cr>"
end
vim.keymap.set('v', 'p', Repl, {silent = true, expr = true})

-- quickfix toggle
function QFixToggle()
  if vim.g.qfix_win ~= nil then
    vim.cmd('cclose')
    vim.g.qfix_win = nil
  else
    vim.cmd('copen 10')
    vim.g.qfix_win = vim.fn.bufnr('$')
  end
end
vim.api.nvim_create_user_command('QFix', function(opts) QFixToggle() end, {})

-- location list toggle
function LFixToggle()
  if vim.g.loc_win ~= nil then
    vim.cmd('lclose')
    vim.g.loc_win = nil
  else
    vim.cmd('lopen 10')
    vim.g.loc_win = vim.fn.bufnr('$')
  end
end
vim.api.nvim_create_user_command('LFix', function(opts) LFixToggle() end, {})

-- elm formatting
function ElmFormat()
  local curw = {}
  xpcall(function() vim.cmd('mkview!') end,
    function() curw = vim.fn.winsaveview() end
  )

  vim.fn['elm#Format']()
  vim.cmd([[
    undojoin | silent %!perl -0777 -p -e "s/->\n\s+/-> /g,s/=\n\s+/= /g,s/( *)(.*) let\n/\1\2\n\1    let\n/g,s/\n\n( *)else/\n\1else/g,s/\n\n\n/\n\n/g"
  ]])

  if vim.tbl_isempty(curw) then
    vim.cmd('silent! loadview')
  else
    vim.fn.winrestview(curw)
  end
end

-- easymotion
vim.g.EasyMotion_leader_key = '<Leader>'

-- ctrlp
vim.g.ctrlp_custom_ignore = {
  dir = [[\v/(\.git|\.hg|\.svn|node_modules|bower_components|tmp|dist|spec/fixtures/vcr_cassettes|public/assets|ebin|toolchain)$]],
  file = [[\v\.(exe|so|dll)$]]
}
vim.g.ctrlp_working_path_mode = 'ra'
vim.g.ctrlp_root_markers = {'.git', 'Makefile', 'package.json', 'REVISION'}
vim.g.ctrlp_switch_buffer = 0
vim.g.ctrlp_max_files = 0
vim.g.ctrlp_max_depth = 30
vim.keymap.set('n', '<C-t>', ':CtrlPTag<CR>')
vim.keymap.set('n', '<C-b>', ':CtrlPBuffer<CR>')

-- logger folding for ts/js
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'javascript'},
  callback = function()
    vim.opt_local.foldmethod = 'marker'
    vim.opt_local.foldmarker = 'Logger.,);'
    vim.opt_local.foldenable = true
    vim.opt_local.foldminlines = 2
    vim.cmd('highlight Folded guibg=background guifg=DarkGrey')
    vim.opt.foldtext = 'v:lua.LoggerFoldText'
  end
})
function LoggerFoldText()
  return '    Logger (folded)'
end

-- latex
vim.g.Tex_DefaultTargetFormat = 'pdf'
vim.g.Tex_ViewRule_pdf = 'evince'
vim.g.Imap_FreezeImap = 1
vim.g.Tex_CompileRule_pdf = 'xelatex -aux-directory=/tmp/xelatex -interaction=nonstopmode $*'
vim.g.Tex_Leader = '`tex'
vim.g.Tex_Leader2 = ',tex'
vim.g.tex_flavor = 'latex'
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function() vim.opt_local.foldenable = false end
})

-- ale
vim.g.ale_linters = {
  -- javascript = {'eslint'},
  typescript = {'ts_ls'},
  go = {'govet'},
}
vim.g.ale_linters_explicit = 1
vim.g.ale_lint_on_text_changed = 0
vim.g.ale_lint_on_filetype_changed = 0
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_save = 1
vim.g.ale_lint_on_insert_leave = 0

vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_def_mapping_enabled = 0
vim.g.go_auto_type_info = 1
vim.g.go_gopls_local = "ably"

-- copilot
vim.g.copilot_node_command = "~/.asdf/installs/nodejs/20.10.0/bin/node"
vim.cmd('highlight CopilotSuggestion guifg=LightGrey ctermfg=LightGrey')
vim.keymap.set('i', '<C-Tab>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-Tab>', '<M-]>')
vim.keymap.set('i', '<S-Tab>', '<M-Right>')

-- lightline
vim.g.lightline = { colorscheme = 'wombat', enable = { tabline = false } }

-- misc plugin settings
vim.g.EditorConfig_exclude_patterns = {'fugitive://.*'}
vim.g.vim_json_syntax_conceal = 0

-- text wrapping for ts/js
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'javascript'},
  callback = function() vim.opt_local.textwidth = 90 end
})

-- ale highlights
vim.cmd([[
  highlight ALEErrorSign guifg=LightGrey ctermfg=LightGrey
  highlight ALEWarningSign guifg=LightGrey ctermfg=LightGrey
  highlight ALEError guifg=LightGrey ctermfg=LightGrey
  highlight ALEWarning guifg=LightGrey ctermfg=LightGrey
]])

-- tab styling
vim.cmd([[
  hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
  hi TabLine ctermfg=Blue ctermbg=Yellow
  hi TabLineSel ctermfg=Red ctermbg=Yellow
]])

-- the backup filename extension adds timestamp
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.opt.backupext = '@' .. os.date("%F.%H:%M")
  end
})

-- per-project vimrc support
if vim.fn.filereadable("._vimrc") == 1 then
  vim.cmd('source ._vimrc')
end

-- window binds:
vim.opt.cursorbind = false
vim.opt.scrollbind = false

-- quick visual star search
vim.cmd([[
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
]])

-- custom gotags/ctags commands 
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.cmd("command! GoTagsReload execute 'find . | grep '.go$' | xargs gotags > tags && echo 'Gotags reloaded'")
  end
})
vim.cmd("command! CTagsReload execute '!ctags -R --exclude=.git --exclude=node_modules . && echo \\'ctags reloaded\\''")

-- word first letter case changing
vim.keymap.set('n', '<leader>U', 'mQgewvU`Q')
vim.keymap.set('n', '<leader>L', 'mQgewvu`Q')

-- underline current line with =
vim.keymap.set('n', '<leader>ul', ':t.<CR>Vr=', {silent = true})

-- find merge conflicts
vim.keymap.set('n', '<leader>fc', '/\\v^[<=>]{7}( .*\\|$)<CR>', {silent = true})

-- easy-align binds
vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)')
vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)')

-- save on ctrl-;
vim.keymap.set('n', '<C-;>', ':update<CR>')

-- vim force redraw on switching tabs to fix buffer corruption issues - no longer needed?
-- vim.opt.ttyfast = true
-- vim.api.nvim_create_autocmd('TabEnter', {
--   pattern = '*',
--   command = 'redraw!'
-- })

-- highlights
vim.cmd('highlight ExtraWhitespace ctermbg=grey guibg=grey')
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '*grep*',
  command = 'cwindow'
})

-- fugitive
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')
