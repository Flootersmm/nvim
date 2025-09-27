require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics in float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Apply code action (clangd fix)" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs in Telescope" })
map("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })
map("v", "<", "<gv", { desc = "Unindent and keep selection" })

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
