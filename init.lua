vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- <Leader> is space
vim.g.maplocalleader = "  "

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

-- Stop default Nvim formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in pairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format { async = false }
        return
      end
    end
  end,
})
vim.schedule(function()
  require "mappings"
end)

-- Makes a `width` wide C-style comment
vim.api.nvim_create_user_command("BannerComment", function(opts)
  local text = opts.args
  local width = 80
  local prefix = "// " .. text .. " "
  local fill_len = width - #prefix
  local line = prefix .. string.rep("/", math.max(fill_len, 0))
  vim.api.nvim_put({ line }, "l", true, true)
end, {
  nargs = 1,
})

vim.g.lsp_autostart = true
