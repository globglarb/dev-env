-- TODO
-- test breakpoints visibility in status column
-- abolish plugin for renaming with semantics like plural singular cases
-- neotest test running
-- lsp file operations antosha417/nvim-lsp-file-operations
-- install missing LSPs / formatter / linter, bash, docker, markdown, etc.
vim.pack.add({
	-- file explorer
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- utilities
	"https://github.com/nvim-lua/plenary.nvim",
	-- UI components, windows, trees, etc.
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended for neo-tree and bufferline
	"https://github.com/nvim-tree/nvim-web-devicons",
	-- optional, but recommended icons
	{ src = "https://github.com/nvim-mini/mini.icons", version = "stable" },
	-- pickers, LSP goto methods, small improvements (scrolling, buffer deletion, etc.)
	{ src = "https://github.com/folke/snacks.nvim", version = vim.version.range("2") },
	-- simple floating command line
	"https://github.com/rachartier/tiny-cmdline.nvim",
	-- flash nvim, navigate with search
	{
		src = "https://github.com/folke/flash.nvim",
		version = vim.version.range("2"),
	},
	-- bufferline
	{
		src = "https://github.com/akinsho/bufferline.nvim",
		version = vim.version.range("4"),
	},
	-- statusline
	"https://github.com/nvim-lualine/lualine.nvim",
	-- color scheme
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	-- sessions
	{
		src = "https://github.com/folke/persistence.nvim",
		version = vim.version.range("3.*"),
	},
	-- git status in status column and hunk navigation
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		name = "gitsigns.nvim",
		version = vim.version.range("2"),
	},
	-- autocompletion with blink
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.cmp",
	-- installer for parsers, queries
	"https://github.com/nvim-treesitter/nvim-treesitter",
	-- pin context to top
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	-- add coding objects like w,p etc.
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	-- nvim surround for surround operations
	"https://github.com/kylechui/nvim-surround",
	-- increment / decrement things
	"https://github.com/monaqa/dial.nvim",
	-- automatic bracket pairing when creating, moves past closing brackets when typing fast
	"https://github.com/windwp/nvim-autopairs",
	-- autotag for working with tags in html, xml, other templating
	"https://github.com/windwp/nvim-ts-autotag",
	-- LSPs and tools with mason
	-- binaries that are hooked into nvim via lspconfig
	"https://github.com/mason-org/mason.nvim",
	-- installs tool binaries
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	-- apply formatting, bridge binary-nvim
	"https://github.com/stevearc/conform.nvim",
	-- apply linting, bridge binary-nvim
	"https://github.com/mfussenegger/nvim-lint",
	-- DAP
	"https://github.com/mfussenegger/nvim-dap",
	-- library used by dap-ui
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
	-- bridge Python debugger to nvim dap
	"https://github.com/mfussenegger/nvim-dap-python",
	-- diffview for merge conflicts and diff viewing
	"https://github.com/sindrets/diffview.nvim",
})

require("tools")
require("editing")
require("keymaps")

-- options
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
-- configure status scolumn
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
-- colors
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")
-- hide redundant status bar
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
-- highlight line number and the cursor
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9e64", bold = true })
-- only save actual values, no blank buffers
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
-- disable surround default mappings
vim.g.nvim_surround_no_normal_mappings = true
-- activate undofile for undos after saving
vim.opt.undofile = true
-- folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
