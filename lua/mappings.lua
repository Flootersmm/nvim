require "nvchad.mappings"

local map = vim.keymap.set

-- map(mode, key_seq, command, opts_list)

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics in float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Apply code action (clangd fix)" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs in Telescope" })
-- map("n", "p", '"0p', { desc = "Paste last yank (register 0)" })
-- map("n", "P", '"0P', { desc = "Paste last yank (register 0) before cursor" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })
map("v", "<", "<gv", { desc = "Unindent and keep selection" })
map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
map(
  "n",
  "<leader>sw",
  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
  { desc = "Search current word" }
)
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
map(
  "n",
  "<leader>sp",
  '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
  { desc = "Search on current file" }
)
map("x", "<leader>re", ":Refactor extract ", { desc = "Refactor extract" })
map("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Refactor extract to file" })
map({ "n", "v" }, "<leader>st", require("stay-centered").toggle, { desc = "Toggle stay-centered.nvim" })

-- Load these only if in a rust file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { silent = true, buffer = bufnr }

    -- Hover with rust-analyzer actions
    map("n", "K", function()
      vim.cmd.RustLsp { "hover", "actions" }
    end, opts)

    -- Code actions with rust-analyzer grouping
    map("n", "<leader>a", function()
      vim.cmd.RustLsp "codeAction"
    end, opts)
  end,
})

-- Load these only if in a c/cpp file
--   Jump to impl and jump to decl
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    for _, client in ipairs(clients) do
      if client.name == "clangd" then
        local opts = { noremap = true, silent = true }

        -- Jump to header (.h/.hpp)
        map("n", "gd", function()
          vim.lsp.buf.declaration()
        end, vim.tbl_extend("force", opts, { desc = "Go to function declaration (header)" }))

        -- Jump to implementation (.c/.cpp), skipping headers if possible
        map("n", "gD", function()
          local params = vim.lsp.util.make_position_params()
          vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
            if err or not result or vim.tbl_isempty(result) then
              return
            end
            -- try to jump to a non-header file first
            for _, res in ipairs(result) do
              if not res.uri:match "%.h$" and not res.uri:match "%.hpp$" then
                vim.lsp.util.jump_to_location(res)
                return
              end
            end
            -- fallback: jump to first result (likely header)
            vim.lsp.util.jump_to_location(result[1])
          end)
        end, vim.tbl_extend("force", opts, { desc = "Go to function implementation (.cpp)" }))

        break
      end
    end
  end,
})

-- Load these only if nvim-dap is loaded
--   nvim-dap is attached only to particular buffer types, like .c
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(event)
    if event.data == "mfussenegger/nvim-dap" then
      local dap = require "dap"
      map("n", "<leader>dc", dap.continue, { desc = "DAP: Continue/Start" })
      map("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end, { desc = "DAP: Set Conditional Breakpoint" })
      map("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
      map("n", "<leader>do", dap.step_over, { desc = "DAP: Step Over" })
      map("n", "<leader>du", dap.step_out, { desc = "DAP: Step Out" })
      map("n", "<leader>dl", dap.run_last, { desc = "DAP: Run Last" })
    end
  end,
})
