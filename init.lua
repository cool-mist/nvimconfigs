V = vim
O = V.opt
OS = package.config:sub(1, 1) == "\\" and "win" or "unix"

-------------
-- Options --
-------------

O.number = true
O.relativenumber = false
O.cursorline = true
O.tabstop = 2
O.shiftwidth = 2
O.expandtab = true
O.preserveindent = true
O.termguicolors = true
O.signcolumn = 'yes:1'
O.ignorecase = true
O.smartcase = true
O.fillchars = { eob = " " }

-- Maintain a history of undos so that I can undo even after restart
O.undofile = true

O.updatetime = 300
O.timeoutlen = 500

-- Keep atleast 15 lines at the bottom, don't scroll beyond
O.scrolloff = 15

O.list = true
O.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
if OS == "win" then
  -- The newer pwsh is faster, but this is required for some legacy functionality
  -- such as [G]o [T]eams below.
  O.shell = "powershell" -- or the newer pwsh
  O.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command"
  O.shellxquote = ''
end
O.clipboard = 'unnamedplus'
O.breakindent = true
O.cmdheight = 1
O.showmode = false
O.laststatus = 0

--------------------
----- Leader -------
--------------------

V.keymap.set('n', " ", "<Nop>", { silent = true, remap = false })
V.g.mapleader = " "

-----------------
-- Lazy conf --
-----------------

-- This clones the lazy repo and initilizes the lazy plugin manager
local lazypath = V.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (V.uv or V.loop).fs_stat(lazypath) then
  V.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
V.opt.rtp:prepend(lazypath)

---------------
--- Plugins ---
---------------

-- Each plugin is defined below with configuration on how to lazy load it.
-- For help check `:h lazy.nvim-lazy.nvim-plugin-spec` for the list of all
-- properties
local lazy = require('lazy')
lazy.setup({
  {
    -------------
    -- Colors  --
    -------------
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
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
      V.cmd([[colorscheme catppuccin-frappe]])
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      theme = "catppuccin-frappe"
    },
  },

  -----------------
  -- Explorer/UI --
  -----------------
  -- Neotree shows opens the current directory in a tree view
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
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
    end,
  },

  -- Telescope is the fuzzy finder UI. It is used to search files, buffers, recent
  -- help tags etc
  {
    "nvim-telescope/telescope.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
    version = false,
    keys = {
      { '<leader>fb', ':Telescope buffers<cr>',    desc = "[F]iles [B]uffers" },
      { '<leader>fo', ':Telescope find_files<cr>', desc = "[F]iles [O]pen" },
      { '<leader>fg', ':Telescope live_grep<cr>',  desc = "[F]iles [G]rep" },
      { '<leader>fh', ':Telescope help_tags<cr>',  desc = "[F]iles [H]elp tags" },
      { '<leader>fr', ':Telescope oldfiles<cr>',   desc = "[F]iles [R]ecent" },
      { '<leader>fn', ':Telescope resume<cr>',     desc = "[F]iles [N]ext on the list" },
    }
  },

  -- Nvim-notify will be plugged into the default vim notify system for a
  -- better notification box
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    event = "VeryLazy",
    config = function()
      require('notify').setup({
        stages = "static",
        timeout = 3000,
        max_height = function()
          return math.floor(V.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(V.o.columns * 0.75)
        end,
        on_open = function(win)
          V.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      })
      V.notify = require("notify")
    end
  },

  -- Dressing.nvim will override the vim.input and vim.select dialog boxes
  -- so that instead of being shown at the bottom, we are presented with a
  -- nice box
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      V.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return V.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      V.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return V.ui.input(...)
      end
    end,
  },

  -- Harpoon is by far the easiest way to keep track of important files and
  -- switch between them while programming.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon.setup({})

      local opts = { noremap = true, silent = true }
      V.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts)
      V.keymap.set('n', '<leader>ha', function() harpoon:list():append() end, opts)
    end
  },

  ---------------
  -- Dev stuff --
  ---------------

  -- Autocompletion plugin. This plugin is reponsible for showing a dialog box
  -- while typing with suggestions. The autocompletion sources have to be separately
  -- configured (for example below the LSP source is configured as one of the available
  -- sources and so the autocomplete dialog box would list it.
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
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
    end
  },

  -- Press g-c to comment a line or a block of text
  -- across many languages
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  -- Used to format markdown tables. And add table of contents to a
  -- markdown document. Used only in my markdown files for taking notes
  {
    "godlygeek/tabular",
    keys = {
      { '<leader>tf', ':TableFormat<cr>', desc = "[T]able [F]ormat" },
      { '<leader>tc', ':Toc<cr>',         "[T]able of [C]ontents" },
    },
  },

  -- Syntax highlighting for markdown documents. Additionally configures
  -- some key bindings and options for markdown files
  {
    "preservim/vim-markdown",
    ft = "markdown.pandoc",
    config = function()
      V.cmd('let g:vim_markdown_folding_disabled = 1')
      V.cmd('let g:vim_markdown_conceal = 0')
      V.cmd('let g:tex_conceal = ""')
      V.cmd('let g:vim_markdown_math = 1')
      V.cmd('let g:vim_markdown_frontmatter = 1')
      V.cmd('let g:vim_markdown_toml_frontmatter = 1')
      V.cmd('let g:vim_markdown_json_frontmatter = 1')

      local opts = { noremap = true, silent = true }
      V.api.nvim_set_keymap('n', '<leader>di', ":pu='{'..strftime('%c')..'}'<cr>", opts)
      V.api.nvim_set_keymap('n', '<leader>fy', ':let @+=@%<cr>', opts)
      V.api.nvim_set_keymap('n', 'gn', 'yi[:e <C-r>*<cr>', opts)
      V.api.nvim_set_keymap('n', 'gm', ':e main.md<cr>', opts)
    end
  },

  -- More syntax highlighting for markdown documents. Update the filetype to
  -- markdown.pandoc so that the syntax highlighting is applied
  {
    "vim-pandoc/vim-pandoc-syntax",
    ft = "markdown",
    config = function()
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

      if OS == "win" then
        -- [G]o [T]eams to copy contents to clipboard so that I can copy paste my
        -- markdown to teams
        local opts = { noremap = true, silent = true }
        V.api.nvim_set_keymap('n', 'gt', ':!pandoc -f markdown-smart -t html % | Set-Clipboard -AsHtml<cr><cr>', opts)
      end
    end
  },

  -- Copilot!!
  {
    "github/copilot.vim",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- lspconfig is the configuration framework for the nvim lsp client. It has best effort
  -- configs for every language. Mason.nvim is the plugin that will install the lsp servers
  -- (and dap servers). Mason-lspconfig is the plugin that will configure the lsp servers
  -- that needs to be installed and available. Otherwise, we can still use the :Mason command
  -- to install the required lsp and dap servers
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('lspconfig').lua_ls.setup({})
      require("lspconfig").powershell_es.setup({})

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

      -- RUST --
      local handlers = {
        ["textDocument/hover"] = V.lsp.with(V.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = V.lsp.with(V.lsp.handlers.signature_help, { border = border }),
      }
      require("lspconfig").rust_analyzer.setup { handlers = handlers }

      -- C# --
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

      -- Add default LSP keybindings
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
          V.keymap.set('n', '<leader>k', V.lsp.buf.signature_help, opts)
          V.keymap.set('n', '<leader>wa', V.lsp.buf.add_workspace_folder, opts)
          V.keymap.set('n', '<leader>wr', V.lsp.buf.remove_workspace_folder, opts)
          V.keymap.set('n', '<leader>wl', function()
            print(V.inspect(V.lsp.buf.list_workspace_folders()))
          end, opts)
          V.keymap.set('n', '<leader>D', V.lsp.buf.type_definition, opts)
          V.keymap.set('n', '<leader>rn', V.lsp.buf.rename, opts)
          V.keymap.set({ 'n', 'v' }, '<leader>ca', V.lsp.buf.code_action, opts)
          V.keymap.set('n', 'gr', V.lsp.buf.references, opts)
          V.keymap.set('n', '<leader>ff', function()
            V.lsp.buf.format { async = true }
          end, opts)
          V.keymap.set('n', '[d', V.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
          V.keymap.set('n', ']d', V.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
          V.keymap.set('n', '<leader>fe', V.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
          V.keymap.set('n', '<leader>fd', V.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
          V.keymap.set('n', '<leader>fe', V.diagnostic.open_float, { desc = 'Open diagnostic message on the line' })
          -- Define some keybinding to build the current solution
          V.keymap.set('n', '<leader>dtb', function()
            V.cmd('!dotnet build')
          end, { silent = true })
        end,
      })
    end,
    dependencies = {
      -- This plugin provides decompilation support for the omnisharp LSP
      "Hoffs/omnisharp-extended-lsp.nvim",
      {
        -- This plugin provides a way to configure which LSP servers to install
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require('mason-lspconfig').setup {
            ensure_installed = {
              "lua_ls",
              "powershell_es",
              "rust_analyzer",
              "omnisharp",
              -- "netcoredbg", Install this manually, this is DAP, not LSP
            }
          }
        end,
        dependencies = {
          -- This plugin provides a way to install LSP and DAP servers
          { "williamboman/mason.nvim", config = true }
        },
      },
    }
  },

  -- This is the DAP client for nvim. Mason (from the previous configuration) still is
  -- responsible for installing the DAP servers. Nvim-Dap is used to configure the different
  -- debug adapters properly
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- This is the UI component of the DAP. It shows the stack, watches, breakpoints, repl etc.
      "rcarriga/nvim-dap-ui",
      config = function()
        local dapui = require('dapui')
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
      end,
      dependencies = {
        -- TODO
        "nvim-neotest/nvim-nio",
      }
    },
    config = function()
      local dap = require('dap')

      -- Netcoredbg is a debug adapter for C# and .NET applications. It needs to be manually
      -- installed at the moment through :Mason and selecting the netcoredbg DAP. The below
      -- configuration tells how to start the netcoredbg process during the debugging process.
      dap.adapters.netcoredbg = {
        type = 'executable',
        command = V.fn.stdpath("data") .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg',
        args = { '--interpreter=vscode' },
        options = {
          detached = false, -- Will put the output in the REPL. #CloseEnough
        }
      }

      -- Below configuration tells how to launch a debugging interactive session for a C#
      -- application when using the netcoredbg adapeter.
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

      -- No idea what the below does, but it is required for the dap to work
      local dapui = require('dapui')
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { '<F5>',       '<cmd>lua require("dap").continue()<cr>',          desc = "Continue" },
      { '<F10>',      '<cmd>lua require("dap").step_over()<cr>',         desc = "Step Over" },
      { '<F11>',      '<cmd>lua require("dap").step_into()<cr>',         desc = "Step Into" },
      { '<F12>',      '<cmd>lua require("dap").step_out()<cr>',          desc = "Step Out" },
      { '<leader>b',  '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
      { '<leader>B',  '<cmd>lua require("dap").set_breakpoint()<cr>',    desc = "Set Breakpoint" },
      { '<leader>dr', '<cmd>lua require("dap").repl.open()<cr>',         desc = "Open REPL" },
      { '<leader>dl', '<cmd>lua require("dap").run_last()<cr>',          desc = "Run Last" },
    }

  },

  -- Shows a popups with the keybindings that are available after a small delay
  {
    "folke/which-key.nvim",
    config = true
  },
})

---------------
-- Key binds --
---------------

-- Some misc keybindings that are not part of any plugin
local keymap = V.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<leader>w', ':w<cr>', opts)
keymap('n', '<leader>q', ':q<cr>', opts)
keymap('n', '<leader>Q', ':qa!<cr>', opts)

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

-- Misc
keymap('n', '<S-u>', ':red<cr>', opts)
keymap('n', '<ESC>', '<cmd>nohlsearch<cr>', {})

----------
-- Misc --
----------

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
