-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- make alias for ] and [ key for German layout
vim.keymap.set({ "n", "v" }, "ä", "]", { remap = true, desc = "Alias for ]" })
vim.keymap.set({ "n", "v" }, "ö", "[", { remap = true, desc = "Alias for ]" })
vim.keymap.set("n", "<leader><tab>ä", "<leader><tab>[", { remap = true, desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>ö", "<leader><tab>]", { remap = true, desc = "Next Tab" })
vim.keymap.set("n", "ü", "/", { remap = true, desc = "Search" })
