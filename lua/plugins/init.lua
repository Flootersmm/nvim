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

  -- CMake
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("cmake-tools").setup {
        build_dir = "build",
        cmake_generator = "Ninja",
      }
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

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,

    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.6),
            max_height = math.floor(vim.o.lines * 0.4),
            pad_top = 0,
            pad_bottom = 0,
          },
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            show_variable_name_hints = true,
            max_len_align = false,
            highlight = "Comment",
          },
        },
        server = {
          on_attach = function(client, bufnr)
            -- standard LSP mappings
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          end,
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              diagnostics = {
                enable = true,
                experimental = { enable = true },
              },
              cargo = {
                allFeatures = true,
              },
              inlayHints = {
                lifetimeElisionHints = { enable = true, useParameterNames = true },
                reborrowHints = { enable = true },
              },
              typing = {
                -- Trigger analysis not just on save, but also as you type
                autoClosingAngleBrackets = true,
              },
              completion = { postfix = { enable = true } }, -- enable postfix completions like `.unwrap()`
              rustfmt = {},
            },
          },
        },
        flags = {
          debounce_text_changes = 150, -- Can impact performance
          allow_incremental_sync = true, -- incremental updates to reduce lag
        },
      }
    end,
  },

  -- Rust crates
  {
    "Saecki/crates.nvim",
    version = "v0.3.0",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
      -- Optional: integrate with LSP hover
      require("crates").show()
    end,
  },

  -- Java
  --   See `custom/java.lua`
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-dap",
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
    },
    config = function()
      -- Setup nvim-java core
      require("java").setup {
        spring_boot_tools = { enable = false },
        jdtls = {
          progressStatus = false, -- disable "project updated" spam
        },
      }

      -- LSP capabilities for nvim-cmp completion
      local lspconfig = require "lspconfig"
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp.default_capabilities(capabilities)
      end

      -- Setup jdtls with silent handlers
      lspconfig.jdtls.setup {
        capabilities = capabilities,
        settings = {
          java = {
            autobuild = { enabled = false },
            configuration = { updateBuildConfiguration = "disabled" },
          },
        },
        handlers = {
          -- Silence noisy JDT LS messages
          ["language/status"] = function() end,
          ["$/progress"] = function() end,
          ["window/logMessage"] = function() end,
          ["window/showMessage"] = function() end,
        },
      }
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
    opts = {
      typst = { enable = false },
    },
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
    event = "LspAttach",
    config = function()
      require("fidget").setup {
        text = { spinner = "dots", done = "✔" },
        align = { bottom = true, right = true },
        timer = { spinner_rate = 125, fidget_decay = 2000, task_decay = 1000 },
        notification = { window = { winblend = 0 } },
      }
    end,
  },

  -- Mini.Operators
  --   Additional motions like `gr` to replace from clipboard
  {
    "nvim-mini/mini.operators",
    version = false,
    config = function()
      require("mini.operators").setup()
    end,
    keys = { "gr", "gR" },
  },

  -- Spectre
  --   Global find and replace
  {
    "nvim-pack/nvim-spectre",
  },

  -- Trouble
  --   Better loclist
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Jupynium
  --   Jupyter notebook support
  {
    "kiyoon/jupynium.nvim",
    build = "python3 -m pip install .",
    config = function()
      require("jupynium").setup()
    end,
  },

  -- Refactoring
  --   Pull out functions, vars, inline functions
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    config = function()
      require("refactoring").setup {
        -- prompt for return type
        prompt_func_return_type = {
          go = true,
          cpp = true,
          c = true,
          java = true,
        },
        -- prompt for function parameters
        prompt_func_param_type = {
          go = true,
          cpp = true,
          c = true,
          java = true,
        },
      }
    end,
  },

  -- Typst-preview
  --   Instant preview for Typst
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    config = function()
      require("typst-preview").setup {
        debug = true,
        open_cmd = "firefox %s",
      }
    end,
  },

  -- Stay-Centered
  --   Applies `zz` after any vertical movement
  {
    "arnamak/stay-centered.nvim",
    lazy = false,
    opts = {
      enabled = false, -- enable with keybind, see mappings.lua
    },
  },
}
