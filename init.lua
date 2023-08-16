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
O.preserveindent=true
O.termguicolors=true
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
packer.startup(function(u)
  u 'wbthomason/packer.nvim'

	-- LSP + Autocomplete
	u 'neovim/nvim-lspconfig'
  u 'williamboman/mason.nvim'
  u 'williamboman/mason-lspconfig.nvim'
  u 'hrsh7th/nvim-cmp'
  u 'hrsh7th/cmp-nvim-lsp'
  u 'hrsh7th/cmp-buffer'
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
	u ({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() V.g.mkdp_filetypes = { "markdown.pandoc" } end, ft = { "markdown" }, })
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
end)

--------------------------
----  Config Section -----
--- 5 --- Plugins conf----
--------------------------

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
				{name = 'nvim_lsp'}
    },
    completion = {
			completeopt = 'menu,menuone,noinsert'
		}
}


local telescope = require('telescope')
telescope.setup();

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

V.keymap.set('n', '<leader>w', ':w<cr>')
V.keymap.set('n', '<leader>q', ':q<cr>')
V.keymap.set('n', '<leader>Q', ':qa!<cr>')
V.keymap.set('n', '<leader>e', ':Neotree toggle float <cr>')
V.keymap.set('n', '<S-u>', ':red<cr>')
V.keymap.set('n', '<leader>;', ':nohl<cr>')
V.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>')
V.keymap.set('n', '<leader>fo', ':Telescope find_files<cr>')
V.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>')
V.keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>')
V.keymap.set('n', '<leader>fr', ':Telescope oldfiles<cr>')
V.keymap.set('n', '<leader>ns', '/Config Section<cr>')
V.keymap.set('n', '<leader>o', 'o<esc>i')
