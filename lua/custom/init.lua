local inlay_hints_enabled = true

function ToggleInlayHints()
  inlay_hints_enabled = not inlay_hints_enabled
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.server_capabilities.inlayHintProvider then
      if inlay_hints_enabled then
        vim.lsp.inlay_hint(0, true)
      else
        vim.lsp.inlay_hint(0, false)
      end
    end
  end
  print("Inlay hints " .. (inlay_hints_enabled and "enabled" or "disabled"))
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require "configs.jdtls"
  end,
})
