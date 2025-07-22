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

if vim.fn.has('gui_running') == 1 then
  vim.opt.guioptions:remove('e')
  if vim.fn.has('gui_gtk') == 1 then
    vim.opt.guifont = 'Meslo LG S for Powerline 10,Noto Color Emoji:h10'

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
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_def_mapping_enabled = 0
vim.g.go_auto_type_info = 1
vim.g.go_gopls_local = "ably"

vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  group = 'AutoFormatting',
  callback = function() vim.lsp.buf.format({ async = false}) end,
})

-- copilot
vim.g.copilot_node_command = "~/.asdf/installs/nodejs/20.10.0/bin/node"
vim.cmd('highlight CopilotSuggestion guifg=LightGrey ctermfg=LightGrey')
vim.keymap.set('i', '<C-Tab>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-Tab>', '<M-]>')
vim.keymap.set('i', '<S-Tab>', '<M-Right>')

-- lightline
vim.g.lightline = { colorscheme = 'edge', enable = { tabline = false } }

-- misc plugin settings
vim.g.EditorConfig_exclude_patterns = {'fugitive://.*'}
vim.g.vim_json_syntax_conceal = 0

-- text wrapping for ts/js
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'javascript'},
  callback = function() vim.opt_local.textwidth = 90 end
})

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
-- function syn_group()
--     local s = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
--     print(vim.fn.synIDattr(s, 'name') .. ' -> ' .. vim.fn.synIDattr(vim.fn.synIDtrans(s), 'name'))
-- end
-- vim.api.nvim_create_user_command('SynGroup', function() syn_group() end, {})
-- vim.keymap.set('n', '<leader>h', ':SynGroup<CR>')

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
    { 'mmalecki/vim-node.js' },
    { 'hwayne/tla.vim' },
    { 'github/copilot.vim', tag = "v1.46.0" }, -- 1.47 and later seem to give weird errors
    -- {
    --   'zbirenbaum/copilot.lua',
    --   config = function()
    --     require("copilot").setup({
    --       copilot_node_command = '/home/simon/.asdf/installs/nodejs/20.10.0/bin/node',
    --     })
    --   end
    -- },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = { 'go', 'javascript', 'typescript', 'elixir', 'markdown' },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true,
          },
        })
      end
    },
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
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition)
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition) -- alternative to C-]
        vim.keymap.set('n', '<leader>gtd', vim.lsp.buf.type_definition) -- alternative to C-[
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
        vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
        vim.keymap.set('n', '<leader>gc', vim.lsp.buf.incoming_calls)
        vim.keymap.set('n', '<leader><leader>', vim.lsp.buf.hover)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
        vim.keymap.set('n', '<leader>f', vim.diagnostic.open_float)
        vim.keymap.set('n', '<C-c>', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<C-x>', vim.diagnostic.goto_prev)
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
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
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
    'nvim-telescope/telescope.nvim', branch = 'master',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'BurntSushi/ripgrep',
        'nvim-telescope/telescope-fzf-native.nvim',
      },
      config = function()
        local builtin = require('telescope.builtin')
        require('telescope').setup({
          defaults = {
            wrap_results = true,
            layout_strategy = 'vertical',
            path_display = { 'truncate' },
            layout_config = {
              width = 0.9,
              height = 0.9,
            },
          },
        })

        -- make ctrl-p fall back to find_files if git_files can't find a .git directory
        -- cache the results of "git rev-parse"
        local is_inside_work_tree = {}
        local project_files = function()
          local opts = {} -- define here if you want to define something

          local cwd = vim.fn.getcwd()
          if is_inside_work_tree[cwd] == nil then
            vim.fn.system("git rev-parse --is-inside-work-tree")
            is_inside_work_tree[cwd] = vim.v.shell_error == 0
          end

          if is_inside_work_tree[cwd] then
            require("telescope.builtin").git_files(opts)
          else
            require("telescope.builtin").find_files(opts)
          end
        end

        vim.keymap.set('n', '<C-p>', project_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<C-b>', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<C-g>', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<C-f>', function()
          builtin.diagnostics({
            severity = { min = vim.diagnostic.severity.WARN }
          })
        end, { desc = 'Telescope diagnostics' })
        vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })

      end,
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
