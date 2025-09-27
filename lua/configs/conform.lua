local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    javascript = { "prettier" },
    html = { "prettier" },
    python = { "isort", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    scala = { "scalafmt" },
    java = { "google-java-format" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
