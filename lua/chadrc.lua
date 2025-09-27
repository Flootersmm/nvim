-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,
  hl_override = {
    -- For some reason, Comment is inlays and @comment is comments idk
    Comment = { fg = "#7f849c", italic = true }, -- Replace with desired color
    ["@comment"] = { fg = "#7f849c" }, -- Treesitter comments
    ["@documentation"] = { fg = "#cba6f7" }, -- Treesitter comments
  },
}

return M
