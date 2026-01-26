-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

vim.o.shell = "/bin/bash"

vim.cmd([[
  let &t_Cs = "\e[4:3m"  " undercurl start
  let &t_Ce = "\e[4:0m"  " underline reset
]])

-- Set diagnostic underlines to undercurl
for _, sign in ipairs({ "Error", "Warn", "Info", "Hint" }) do
  vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. sign, { undercurl = true })
end

-- Spelling (if you use :set spell)
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#f87171" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#facc15" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#a78bfa" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#10b981" })
