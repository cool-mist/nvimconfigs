V = vim
OS = package.config:sub(1, 1) == "\\" and "win" or "unix"

-------------
-- Options --
-------------

O = V.opt
O.number = true
O.relativenumber = false
O.cursorline = true
O.tabstop = 2
O.shiftwidth = 2
O.expandtab = true
O.preserveindent = true
O.termguicolors = true
O.showmode = false
O.signcolumn = 'yes:1'
O.ignorecase = true
O.smartcase = true
O.fillchars = { eob = " " }
O.showmode = false

-- Maintain a history of undos so that I can undo even after restart
O.undofile = true
O.updatetime = 300
O.timeoutlen = 500

-- Keep atleast 15 lines at the bottom, don't scroll beyond
O.scrolloff = 15
O.list = true
O.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
if OS == "win" then
  O.shell = "powershell" -- or the newer pwsh
  O.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command"
  O.shellxquote = ''
end
O.clipboard = 'unnamedplus'
O.breakindent = true
O.cmdheight = 1

-----------------
-- Packer conf --
-----------------

V.keymap.set('n', " ", "<Nop>", { silent = true, remap = false })
V.g.mapleader = " "

-- On a fresh install, clone and install packer
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

local fresh_install = fresh_install_packer()

----------------------
--- Auto commands ----
----------------------

-- Automatically call PackerCompile when init.lua is saved
V.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Auto compile init.lua on config update',
  pattern = 'init.lua',
  group = V.api.nvim_create_augroup('packer_user_config', { clear = true }),
  callback = function()
    V.api.nvim_command('source % | PackerCompile')
  end
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
V.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = V.api.nvim_create_augroup('highlight-on-yank', { clear = true }),
  callback = function()
    V.highlight.on_yank()
  end,
})

--------------------
----- Leader -------
--------------------

V.keymap.set('n', " ", "<Nop>", { silent = true, remap = false })
V.g.mapleader = " "

---------------
--- Plugins ---
---------------

local packer = require('packer')

packer.startup({
  function(u)
    u 'nvim-lua/plenary.nvim'
    u 'wbthomason/packer.nvim'

    -- Colorscheme
    u {
      'catppuccin/nvim', as = 'catppuccin'
    }

    -- AI
    u 'github/copilot.vim'

    -- Dev stuff
    u 'williamboman/mason.nvim'
    u 'williamboman/mason-lspconfig.nvim'
    u 'neovim/nvim-lspconfig'
    u 'hrsh7th/nvim-cmp'
    u 'hrsh7th/cmp-nvim-lsp'
    u 'hrsh7th/cmp-buffer'
    u 'hrsh7th/cmp-path'
    u 'j-hui/fidget.nvim'
    u 'numToStr/Comment.nvim'
    u 'mfussenegger/nvim-dap'
    u 'nvim-neotest/nvim-nio'
    u 'rcarriga/nvim-dap-ui'
    u 'Hoffs/omnisharp-extended-lsp.nvim'
    u {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      requires = { { "nvim-lua/plenary.nvim" } }
    }

    -- Markdown
    u 'godlygeek/tabular'
    u 'preservim/vim-markdown'
    u 'vim-pandoc/vim-pandoc-syntax'
    u 'junegunn/goyo.vim'

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
    }
  }
})

-------------------
--- Plugins conf---
-------------------

require('catppuccin').setup({
  flavour = "frappe", -- latte, frappe, macchiato, mocha
  background = {      -- :h background
    light = "frappe",
    dark = "mocha",
  },
  transparent_background = true, -- disables setting the background color.
  show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
  term_colors = false,           -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false,             -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15,           -- percentage of the shade to apply to the inactive window
  },
  no_italic = false,             -- Force no italic
  no_bold = false,               -- Force no bold
  no_underline = false,          -- Force no underline
  styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "bold" },       -- Change the style of comments
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

V.api.nvim_command("colorscheme catppuccin-frappe")

require('neo-tree').setup({
  window = {
    width = 40,
    position = 'right',
    auto_resize = true,
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
  },
})

require('telescope').setup()


-- LSP, DAP

-- The default borders from nvim-lspconfig, which is what is used to configure the lsp servers
-- in this configuration, are not visible. This is a workaround to update the borders key in the
-- corresponding lsp handlers for hover and signature_help. This is a workaround until I implement
-- lsp configs per language manually
V.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
V.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

local border = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}

require("mason").setup()
require("mason-lspconfig").setup()
local dap = require('dap')
local dapui = require('dapui')

-- Rust
local handlers = {
  ["textDocument/hover"] = V.lsp.with(V.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = V.lsp.with(V.lsp.handlers.signature_help, { border = border }),
}
require("lspconfig").rust_analyzer.setup { handlers = handlers }

-- C#
local omnisharp_extended = require("omnisharp_extended") -- decompilation support
local omnisharp_handlers = {
  ["textDocument/hover"] = V.lsp.with(V.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = V.lsp.with(V.lsp.handlers.signature_help, { border = border }),
  ["textDocument/definition"] = omnisharp_extended.definition_handler,
  ["textDocument/references"] = omnisharp_extended.references_handler,
  ["textDocument/implementation"] = omnisharp_extended.implementation_handler,
}

require("lspconfig").omnisharp.setup {
  handlers = omnisharp_handlers,
  enable_editorconfig_support = true,
  enable_ms_build_load_projects_on_demand = false,
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = false,
  sdk_include_prereleases = true,
  analyze_open_documents_only = true,
}

dap.adapters.netcoredbg = {
  type = 'executable',
  command = V.fn.stdpath("data") .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg',
  args = { '--interpreter=vscode' },
  options = {
    detached = false, -- Will put the output in the REPL. #CloseEnough
  }
}

dap.configurations.cs = {
  {
    type = "netcoredbg",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return V.fn.input('DLL: ', V.fn.getcwd() .. '/bin/Debug/net8.0/', 'file')
    end,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal"
  },
}

-- Lua
require("lspconfig").lua_ls.setup {}

-- Powershell
require("lspconfig").powershell_es.setup {}

-- General LSP keybindings

V.api.nvim_create_autocmd('LspAttach', {
  group = V.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    V.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    V.keymap.set('n', 'gD', V.lsp.buf.declaration, opts)
    V.keymap.set('n', 'gd', V.lsp.buf.definition, opts)
    V.keymap.set('n', 'K', V.lsp.buf.hover, opts)
    V.keymap.set('n', 'gi', V.lsp.buf.implementation, opts)
    -- V.keymap.set('n', '<space>k', V.lsp.buf.signature_help, opts)
    -- V.keymap.set('n', '<space>wa', V.lsp.buf.add_workspace_folder, opts)
    -- V.keymap.set('n', '<space>wr', V.lsp.buf.remove_workspace_folder, opts)
    -- V.keymap.set('n', '<space>wl', function()
    --   print(V.inspect(V.lsp.buf.list_workspace_folders()))
    -- end, opts)
    V.keymap.set('n', '<space>D', V.lsp.buf.type_definition, opts)
    V.keymap.set('n', '<space>rn', V.lsp.buf.rename, opts)
    V.keymap.set({ 'n', 'v' }, '<space>ca', V.lsp.buf.code_action, opts)
    V.keymap.set('n', 'gr', V.lsp.buf.references, opts)
    V.keymap.set('n', '<space>ff', function()
      V.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- General DAP settings

V.keymap.set('n', '<F5>', function() require('dap').continue() end)
V.keymap.set('n', '<F10>', function() require('dap').step_over() end)
V.keymap.set('n', '<F11>', function() require('dap').step_into() end)
V.keymap.set('n', '<F12>', function() require('dap').step_out() end)
V.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
V.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
V.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
V.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = V.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        -- "breakpoints",
        "stacks",
        "watches",
      },
      size = 70, -- 40 columns
      position = "right",
    },
    {
      elements = {
        "repl",
        -- "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = false,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil,  -- These can be integers or a float between 0 and 1.
    max_width = nil,   -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local cmp = require('cmp')
cmp.setup {
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    }),
  },
  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'path' }
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  }
}

require('Comment').setup();

local whichkey = require('which-key')
whichkey.setup()

local harpoon = require('harpoon')
harpoon.setup()

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

---------------
-- Key binds --
---------------

local keymap = V.api.nvim_set_keymap
local luakeymap = V.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>w', ':w<cr>', opts)
keymap('n', '<leader>q', ':q<cr>', opts)
keymap('n', '<leader>Q', ':qa!<cr>', opts)

-- Neotree
keymap('n', '<leader>e', ':Neotree reveal toggle<cr>', opts)

-- Telescope
keymap('n', '<leader>fb', ':Telescope buffers<cr>', opts)
keymap('n', '<leader>fo', ':Telescope find_files<cr>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<cr>', opts)
keymap('n', '<leader>fh', ':Telescope help_tags<cr>', opts)
keymap('n', '<leader>fr', ':Telescope oldfiles<cr>', opts)
keymap('n', '<leader>fn', ':Telescope resume<cr>', opts)

-- Navidate windows
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprev<CR>", opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<cr>gv-gv", opts)
keymap("x", "K", ":move '<-2<cr>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<cr>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<cr>gv-gv", opts)

-- Diagnostics
keymap('n', '<space>fe', ":lua vim.diagnostic.open_float()<cr>", opts)

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
if OS == "win" then
  -- [G]o [T]eams to copy contents to clipboard so that I can copy paste my
  -- markdown to teams
  keymap('n', 'gt', ':!pandoc -f markdown-smart -t html % | Set-Clipboard -AsHtml<cr><cr>', opts)
end

-- Present
keymap('n', '<leader>g', ':Goyo<cr>', opts)

-- Diagnostics
luakeymap('n', '[d', V.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
luakeymap('n', ']d', V.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
luakeymap('n', '<leader>fe', V.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
luakeymap('n', '<leader>fd', V.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Misc
keymap('n', '<S-u>', ':red<cr>', opts)
keymap('n', '<ESC>', '<cmd>nohlsearch<cr>', {})

-- Harpoon
luakeymap('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts)
luakeymap('n', '<leader>ha', function() harpoon:list():append() end, opts)
