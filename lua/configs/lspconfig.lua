local nvlsp = require "nvchad.configs.lspconfig"

-- servers you want with default settings
local servers = { "html", "cssls", "clangd", "metals", "rust_analyzer", "pyright", "lean" }

for _, server in ipairs(servers) do
  vim.lsp.config[server].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Clangd
--   `cmd` options are self explanatory
--   Prevents default Nvim formatting until it's loaded
vim.lsp.config.clangd.setup {
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
  capabilities = nvlsp.capabilities,
  root_dir = vim.fs.root(0, { "compile_commands.json", ".git" }),
}

-- Rust
--   `settings` are self explanatory
vim.lsp.config.rust_analyzer.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = { "rust" },
  root_dir = vim.fs.root(0, { "Cargo.toml" }),
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      inlayHints = {
        enable = true,
        parameterHints = true,
        typeHints = true,
      },
    },
  },
}
