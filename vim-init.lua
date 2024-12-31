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

vim.opt.termguicolors = true
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
-- nb: deliberately not using wildcharm, whose lightline colorscheme isn't good
vim.g.lightline = { colorscheme = 'edge', enable = { tabline = false } }

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
-- vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)')
-- vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)')

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

-- view current highlight group
function syn_group()
    local s = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
    print(vim.fn.synIDattr(s, 'name') .. ' -> ' .. vim.fn.synIDattr(vim.fn.synIDtrans(s), 'name'))
end
vim.api.nvim_create_user_command('SynGroup', function() syn_group() end, {})
vim.keymap.set('n', '<leader>h', ':SynGroup<CR>')

-- swap-lines
local function swap_lines(n1, n2)
 local line1 = vim.fn.getline(n1)
 local line2 = vim.fn.getline(n2)
 vim.fn.setline(n1, line2)
 vim.fn.setline(n2, line1)
end

local function swap_up()
 local n = vim.fn.line('.')
 if n == 1 then return end
 swap_lines(n, n - 1)
 vim.cmd(tostring(n - 1))
end

local function swap_down()
 local n = vim.fn.line('.')
 if n == vim.fn.line('$') then return end
 swap_lines(n, n + 1)
 vim.cmd(tostring(n + 1))
end

vim.keymap.set('n', '<a-k>', swap_up, {silent = true})
vim.keymap.set('n', '<a-j>', swap_down, {silent = true})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  defaults = {
    lazy = false,
  },
  spec = {
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-surround' },
    { 'tpope/vim-endwise' },
    { 'editorconfig/editorconfig-vim' },
    { 'junegunn/vim-easy-align' },
    { 'ddollar/nerdcommenter' },
    { 'easymotion/vim-easymotion' },
    { 'bronson/vim-trailing-whitespace' },
    { 'mbbill/undotree' },
    { 'itchyny/lightline.vim' },
    { 'ctrlpvim/ctrlp.vim' },
    { 'dense-analysis/ale' },
    { 'mmalecki/vim-node.js' },
    { 'hwayne/tla.vim' },
    { 'github/copilot.vim' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    {
      'neovim/nvim-lspconfig',
      config = function()
        lspconfig = require('lspconfig');
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        lspconfig.ts_ls.setup{
          capabilities = capabilities,
        }
        lspconfig.gopls.setup({
          capabilities = capabilities,
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
            },
          },
        })
        vim.keymap.set('n', '<C-[>', vim.lsp.buf.type_definition)
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition) -- alternative to C-]
        vim.keymap.set('n', '<leader>gtd', vim.lsp.buf.type_definition) -- alternative to C-[
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
        vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
        vim.keymap.set('n', '<leader>gc', vim.lsp.buf.incoming_calls)
        vim.keymap.set('n', '<leader><leader>', vim.lsp.buf.hover)
      end
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
      },
      lazy = false,
      config = function()
        local cmp = require('cmp')
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ['<C-S-n>'] = cmp.mapping.scroll_docs(-1),
            ['<C-o>'] = cmp.mapping.complete(),
          }),
          completion = {
            autocomplete = false
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
          }
        })
      end
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      opts = {
        -- disable obnoxious hints in visual mode
        hints = { enabled = false },
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
    {
      "EdenEast/nightfox.nvim",
      -- config = function() vim.cmd('colorscheme wildcharm') end,
      -- priority = 1000  -- load before everything else
    },
    {
      "sainnhe/edge",
      config = function() vim.cmd('colorscheme edge') end,
      priority = 1000  -- load before everything else
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "edge" } },
  -- automatically check for plugin updates
  checker = { enabled = false, notify = false },
})
