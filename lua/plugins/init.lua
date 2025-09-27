return {
  -- LSP
  --   Handler of non-plugin LSPs
  --   See `configs/lspconfig.lua`
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Scala / Metals
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("ScalaFormatOnSave", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
      end
      return metals_config
    end,
    config = function(self, metals_config)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
      })
    end,
  },

  -- Rust (rust-tools wraps rust-analyzer)
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
    config = function()
      local nvlsp = require "nvchad.configs.lspconfig"
      require("rust-tools").setup {
        server = {
          on_attach = function(client, bufnr)
            nvlsp.on_attach(client, bufnr)
            vim.keymap.set("n", "<Leader>rh", ":RustHoverActions<CR>", { buffer = bufnr, desc = "Rust Hover Actions" })
          end,
          capabilities = nvlsp.capabilities,
        },
        tools = { autoSetHints = true },
      }
    end,
  },

  -- Java
  --   See `custom/java.lua`
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
    config = function()
      require("java").setup {}
      local nvlsp = require "nvchad.configs.lspconfig"

      vim.lsp.config("jdtls", {
        on_attach = nvlsp.on_attach,
        capabilities = nvlsp.capabilities,
        filetypes = { "java" },
      })
      vim.lsp.enable "jdtls"
    end,
  },

  -- -- Lean
  -- {
  --   "Julian/lean.nvim",
  --   event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  --
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim", -- for 2 Lean-specific pickers
  --   },
  --
  --   opts = {
  --     mappings = true,
  --     lsp = {
  --       init_options = {
  --         editDelay = 0,
  --         hasWidgets = true,
  --       },
  --     },
  --
  --     ft = {
  --       nomodifiable = {},
  --     },
  --
  --     abbreviations = {
  --       enable = true,
  --       extra = {
  --         wknight = "♘",
  --       },
  --       leader = "\\",
  --     },
  --
  --     infoview = {
  --       autoopen = true,
  --
  --       width = 50,
  --       height = 20,
  --
  --       horizontal_position = "bottom",
  --
  --       separate_tab = false,
  --
  --       indicators = "auto",
  --     },
  --
  --     progress_bars = {
  --       enable = true
  --       character = "│",
  --       priority = 10,
  --     },
  --
  --     stderr = {
  --       enable = true,
  --       height = 5,
  --       on_lines = nil,
  --     },
  --   },
  -- },

  -- Haskell
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6",
    ft = { "haskell", "lhaskell" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --     ░█▄█░▀█▀░█▀▀░█▀▀░█▀▀░█░░░█░░░█▀█░█▀█░█▀▀░█▀█░█░█░█▀▀     --
  --     ░█░█░░█░░▀▀█░█░░░█▀▀░█░░░█░░░█▀█░█░█░█▀▀░█░█░█░█░▀▀█     --
  --     ░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀     --
  ------------------------------------------------------------------
  ------------------------------------------------------------------

  -- Treesitter
  --   Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = { "OXY2DEV/markview.nvim" },
    opts = {
      ensure_installed = { "vim", "lua", "vimdoc", "html", "css" },
    },
  },

  -- Nvim-tree
  --   File explorer
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = {
      git = {
        ignore = false,
        show_on_dirs = true,
      },
      filters = {
        custom = {},
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  -- Conform
  --   Linting
  --   See `configs/conform.lua`
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- Nvim-dap
  --   Debugger
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
      local dap = require "dap"

      require("dap").adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=mi2" },
      }

      require("dap").configurations.cpp = {
        {
          name = "Launch file",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp
      vim.keymap.set("n", "dr", function()
        dap.continue()
      end, { desc = "DAP Run" })
    end,
  },

  -- Auto-session
  --   Restore sessions automatically
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
  },

  -- Neoscroll
  --   Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup {
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "sine",
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      }
    end,
  },

  -- Markview
  --   Markdown prettifier and inline LaTeX
  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy",
  },

  -- Todo-comments
  --   Highlight comments and view with Telescope
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },

  -- LSP_signature
  --   Function signatures as you type
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
      require("lsp_signature").setup {
        bind = true,
        floating_window = false, -- disable automatic popup
        hint_prefix = "",
        handler_opts = { border = "rounded" },
        floating_window_above_cur_line = true,
      }
    end,
  },

  -- Surround
  --   Binds to surround text in punctuation
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Fidget
  --   Better notifications from LSP etc.
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
}
