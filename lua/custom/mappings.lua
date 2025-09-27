local M = {}

M.general = {
  n = {
    ["<Leader>i"] = { ":lua ToggleInlayHints()<CR>", "Toggle inlay hints" },
  },
  t = {
    ["<Esc>"] = { [[<C-\><C-n>]], "Exit terminal mode" },
  },
}

M.mappings.dap_continue = "<leader>dc"

return M
