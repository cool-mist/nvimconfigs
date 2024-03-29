V = vim

--------------------------
----  Config Section -----
--- 1 --- Options --------
--------------------------
O = V.opt

-- Show numebers. Relative numbers are useful if you want to jump up and down
-- using the <num>j or <num>k commands. But I prefer to use the <num>G command
O.number=true
O.relativenumber=false
O.cursorline=true

-- Pretty much the standard now-a-days.
O.tabstop=2
O.shiftwidth=2
O.expandtab=true
O.preserveindent=true

O.termguicolors=true
O.showmode=false
O.signcolumn="yes"

-- Useful to search this way
O.ignorecase=true
O.smartcase=true

-- Maintain a history of undos so that I can undo even after restart
O.undofile=true

O.updatetime=300
O.timeoutlen=500

-- Keep atleast 15 lines at the bottom, don't scroll beyond
O.scrolloff=15

O.list = true
O.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- If running on WSL + Arch, uncomment this for faster startup
-- before setting the clipbard to unnamedplus
-- V.g.clipboard = {
--  name = 'win32yank',
--  copy = {
--     ["+"] = 'win32yank.exe -i --crlf',
--     ["*"] = 'win32yank.exe -i --crlf',
--   },
--  paste = {
--     ["+"] = 'win32yank.exe -o --lf',
--     ["*"] = 'win32yank.exe -o --lf',
--  },
--  cache_enabled = 0,
--}
O.clipboard='unnamedplus'

--------------------------
----  Config Section -----
--- 2 --- Leader ---------
--------------------------

V.keymap.set('n', " ", "<Nop>", {silent = true, remap = false})
V.g.mapleader = " "

--------------------------
----  Config Section -----
--- 3 --- Packer conf ----
--------------------------
local fresh_install_packer = function()
  local packerpath = V.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if not V.loop.fs_stat(packerpath) then
    V.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim.git",
      packerpath,
    })
    V.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local fresh_install = fresh_install_packer();

V.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])

--------------------------
----  Config Section -----
--- 4 --- Plugins --------
--------------------------

local packer = require('packer')

packer.startup({function(u)
  u 'wbthomason/packer.nvim'

  -- Colorscheme
  u {
    'catppuccin/nvim', as = 'catppuccin'
  }

  -- AI
  u 'github/copilot.vim'

  -- Dev
  u 'williamboman/mason.nvim'
  u 'williamboman/mason-lspconfig.nvim'
  u 'neovim/nvim-lspconfig'
  u 'hrsh7th/nvim-cmp'
  u 'hrsh7th/cmp-nvim-lsp'
  u 'hrsh7th/cmp-buffer'
  u 'hrsh7th/cmp-path'
  u 'numToStr/Comment.nvim'
  u {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  }

  -- Markdown
  u 'godlygeek/tabular'
  u 'preservim/vim-markdown'
  u 'vim-pandoc/vim-pandoc-syntax'
  u 'junegunn/goyo.vim'
  u 'junegunn/limelight.vim'

  -- File tree, telescope
  u 'nvim-lua/plenary.nvim'
  u 'nvim-tree/nvim-web-devicons'
  u 'MunifTanjim/nui.nvim'
  u {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x'
  }
  u {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x'
  }

  -- Others
  u 'itchyny/lightline.vim'
  u 'folke/which-key.nvim'

  if fresh_install then
    packer.sync()
  end
end,
config = {
  max_jobs = 50,
  git = {
    cmd = 'git',
    subcommands = {
      update         = 'pull --ff-only --progress --rebase=false --force',
      install        = 'clone --depth %i --no-single-branch --progress',
      fetch          = 'fetch --depth 1 --progress --force',
      checkout       = 'checkout %s --',
      update_branch  = 'merge --ff-only @{u}',
      current_branch = 'branch --show-current',
      diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
      diff_fmt       = '%%h %%s (%%cr)',
      get_rev        = 'rev-parse --short HEAD',
      get_msg        = 'log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1',
      submodules     = 'submodule update --init --recursive --progress'
    },
    depth = 1,
    clone_timeout = 5, -- in seconds
    default_url_format = 'https://github.com/%s'
  },
}})

--------------------------
----  Config Section -----
--- 5 --- Plugins conf----
--------------------------

V.cmd("colorscheme catppuccin-frappe")

require('telescope').setup()

require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").rust_analyzer.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>ff', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local cmp = require('cmp')
cmp.setup {
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }),
    },
    sources = {
        {name = 'buffer'},
        {name = 'nvim_lsp'},
        {name = 'path'}
    },
    completion = {
      completeopt = 'menu,menuone,noinsert'
    }
}

local whichkey = require('which-key')
whichkey.setup()

-- vim-markdown
V.cmd('let g:vim_markdown_folding_disabled = 1')
V.cmd('let g:vim_markdown_conceal = 0')
V.cmd('let g:tex_conceal = ""')
V.cmd('let g:vim_markdown_math = 1')
V.cmd('let g:vim_markdown_frontmatter = 1')
V.cmd('let g:vim_markdown_toml_frontmatter = 1')
V.cmd('let g:vim_markdown_json_frontmatter = 1')

V.cmd([[
  augroup pandoc_syntax
      au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  augroup END
]])

V.cmd([[
  augroup pandoc_syntax
      au! BufNewFile,BufFilePre,BufRead *.markdown set filetype=markdown.pandoc
  augroup END
]])

require('Comment').setup()

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'bash', 'c', 'html', 'html', 'markdown', 'vim', 'vimdoc', 'rust' },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
}

--------------------------
----  Config Section -----
--- x --- Neovide --------
--------------------------

if V.g.neovide then
    -- V.g.neovide_fullscreen = true
    V.g.neovide_cursor_animation_length = 0.05
    V.g.neovide_transparency = 0.85
    V.g.neovide_refresh_rate_idle = 5
    V.g.neovide_cursor_trail_size = 0.2
    V.g.neovide_cursor_vfx_mode = "railgun"
end

--------------------------
----  Config Section -----
--- x --- Keybindings ----
--------------------------

local keymap = V.api.nvim_set_keymap
local lua_keymap = V.keymap
local opts = { noremap = true, silent = true }

keymap('n', '<leader>w', ':w<cr>', opts)
keymap('n', '<leader>q', ':q<cr>', opts)
keymap('n', '<leader>Q', ':qa!<cr>', opts)

-- Neotree
keymap('n', '<leader>e', ':Neotree toggle <cr>', opts)

-- Telescope
keymap('n', '<leader>fb', ':Telescope buffers<cr>', opts)
keymap('n', '<leader>fo', ':Telescope find_files<cr>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<cr>', opts)
keymap('n', '<leader>fh', ':Telescope help_tags<cr>', opts)
keymap('n', '<leader>fr', ':Telescope oldfiles<cr>', opts)

-- Navidate windows
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "p", '"_dP', opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<cr>gv-gv", opts)
keymap("x", "K", ":move '<-2<cr>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<cr>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<cr>gv-gv", opts)

-- terminal
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
keymap("n", "tt", ":ToggleTerm<cr>", opts)
keymap("x", "tt", ":ToggleTerm<cr>", opts)


-- Notes
keymap('n', '<leader>tf', ':TableFormat<cr>', opts)
keymap('n', '<leader>tc', ':Toc<cr>', opts)
keymap('n', '<leader>di', ":pu='{'..strftime('%c')..'}'<cr>", opts)
keymap('n', '<leader>o', 'o<esc>i', opts)
keymap('n', '<leader>fy', ':let @+=@%<cr>', opts)
keymap('n', 'gn', 'yi[:e <C-r>*<cr>', opts)
keymap('n', 'gm', ':e main.md<cr>', opts)

-- Present
keymap('n', '<leader>g', ':Goyo<cr>', opts)
keymap('n', '<leader>l', ':Limelight!! 0.9<cr>', opts)

-- Diagnostics
lua_keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
lua_keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
lua_keymap.set('n', '<leader>ed', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
lua_keymap.set('n', '<leader>fd', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Neovide
if V.g.neovide then
  keymap('n', '<leader>ff', ':lua V.g.neovide_fullscreen = true<cr>', opts)
end

-- Misc
keymap('n', '<S-u>', ':red<cr>', opts)
keymap('n', '<leader>;', ':nohl<cr>', opts)
keymap('n', '<leader>ns', '/Config Section<cr>', opts)
