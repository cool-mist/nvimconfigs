V = vim

--------------------------
----  Config Section -----
--- 1 --- Options --------
--------------------------
O = V.opt
O.number=true
O.relativenumber=true
O.tabstop=2
O.shiftwidth=2
O.expandtab=true
O.preserveindent=true
O.termguicolors=true
O.clipboard='unnamedplus'
V.cmd("colorscheme habamax")

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

  -- LSP + Autocomplete
  u 'neovim/nvim-lspconfig'
  u 'williamboman/mason.nvim'
  u 'williamboman/mason-lspconfig.nvim'
  u 'hrsh7th/nvim-cmp'
  u 'hrsh7th/cmp-nvim-lsp'
  u 'hrsh7th/cmp-buffer'
  u 'hrsh7th/cmp-path'
  u 'L3MON4D3/LuaSnip'
  u 'Sirver/ultisnips'
  u 'honza/vim-snippets'
  u {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x'
  }

  -- Markdown
  u 'godlygeek/tabular'
  u 'elzr/vim-json'
  u 'preservim/vim-markdown'
  u 'vim-pandoc/vim-pandoc-syntax'

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
  u 'nvim-lualine/lualine.nvim'
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
      fetch          = 'fetch --depth 999999 --progress --force',
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

local telescope = require('telescope')
telescope.setup();

local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
  'lua_ls',
  'tsserver',
  'eslint',
  'rust_analyzer'
})

lsp.setup();

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

local lualine = require('lualine')
lualine.setup({
  options = {
    theme = 'nord'
  }
});

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

--------------------------
----  Config Section -----
--- x --- Keybindings ----
--------------------------

local keymap = V.api.nvim_set_keymap
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
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Notes
keymap('n', '<leader>tf', ':TableFormat<cr>', opts)
keymap('n', '<leader>o', 'o<esc>i', opts)
keymap('n', '<leader>fy', ':let @+=@%<cr>', opts)
keymap('n', 'gn', 'yi[:e <C-r>*<cr>', opts)
keymap('n', 'gm', ':e main.md<cr>', opts)

-- Misc
keymap('n', '<S-u>', ':red<cr>', opts)
keymap('n', '<leader>;', ':nohl<cr>', opts)
keymap('n', '<leader>ns', '/Config Section<cr>', opts)
