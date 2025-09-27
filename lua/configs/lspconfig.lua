local nvlsp = require "nvchad.configs.lspconfig"

-- servers you want with default settings
local servers = { "html", "cssls", "pyright" }

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(server)
end

-- Clangd
--   `cmd` options are self explanatory
--   Prevents default Nvim formatting until it's loaded
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--compile-commands-dir=.",
    "--clang-tidy",
    "--fallback-style=none",
    "--enable-config",
    "--header-insertion=never",
  },
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
  caparoot_dir = function(params)
    local fname = type(params) == "table" and params.bufname or params

    local found = vim.fs.find({ "compile_commands.json", ".git" }, {
      path = fname,
      upward = true,
    })[1]

    if found then
      return vim.fs.dirname(found)
    else
      return vim.loop.cwd()
    end
  end,
})
vim.lsp.enable "clangd"
