-- TODO
-- test breakpoints in status column
-- keymaps for closing other buffers, buffers to the right/left
-- plugins lspconfig
-- dap.lua
-- dap-ui
-- dap virtual text
-- diffview?
-- abolish for renaming with semantics like plural singular cases
-- check if snacks LSP keymaps are useful
-- test running with neotest
-- lsp file operations antosha417/nvim-lsp-file-operations
-- plugin for JSON schema validation / hints
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
	{
		src = "https://github.com/VonHeikemen/fine-cmdline.nvim",
		version = "main",
	},
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
	-- LSPs and tools with mason, mason-lspconfig allows for registering the server and tool
	-- binaries that are hooked into nvim via lspconfig
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	-- formatting
	"https://github.com/stevearc/conform.nvim",
	-- linting
	"https://github.com/mfussenegger/nvim-lint",
})

require("mason").setup()
-- mason names, mapped to lspconfig names and configuration
require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP servers (same as the LazyVim example stack)
		"pyright", -- Python
		"typescript-language-server", -- TS/JS (ts_ls)
		"json-lsp", -- JSON (jsonls)

		-- formatter
		"stylua",
		"shfmt",

		-- Linters from the LazyVim example
		"shellcheck",
		"ruff",

		-- DAP typescript
		"js-debug-adapter",
	},
	auto_update = false,
	run_on_start = true,
})

-- LSP and tool configs
vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				-- typeCheckingMode = "basic",
				autoImportCompletions = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
})

-- linting
vim.lsp.config("ruff", {
	init_options = {
		settings = {
			-- Optional editor-side overrides. Everything else comes from pyproject.toml
			-- lineLength = 100,
			-- configuration = "~/.config/ruff/ruff.toml",  -- force a specific config file
		},
	},
})

vim.lsp.enable({ "pyright", "ts_ls", "jsonls" })
-- formatters
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "never" },
})

-- linters
require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	python = { "ruff" },
}

-- needed for pinning of function on top etc., other functionality
require("nvim-treesitter").install({ "python", "typescript", "html", "javascript", "svelte", "xml" })
-- auto tags
require("nvim-ts-autotag").setup()
-- autopairs
require("nvim-autopairs").setup({})
-- neo-tree
require("neo-tree").setup({})

-- dial config for incrementing / decrementing
-- increment / decrement with dial.nvim
local augend = require("dial.augend")

local logical_alias = augend.constant.new({
	elements = { "&&", "||" },
	word = false,
	cyclic = true,
})

local ordinal_numbers = augend.constant.new({
	elements = {
		"first",
		"second",
		"third",
		"fourth",
		"fifth",
		"sixth",
		"seventh",
		"eighth",
		"ninth",
		"tenth",
	},
	word = false,
	cyclic = true,
})

local months = augend.constant.new({
	elements = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	},
	word = true,
	cyclic = true,
})

require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal, -- 0, 1, 2, ...
		augend.integer.alias.decimal_int, -- also negative
		augend.integer.alias.hex, -- 0x01, 0x3f3f
		augend.date.alias["%Y/%m/%d"], -- 2026/08/01
		augend.constant.alias.en_weekday, -- Mon, Tue, ..., Sun
		augend.constant.alias.en_weekday_full, -- Monday, ..., Sunday
		ordinal_numbers, -- first <-> tenth
		months, -- January <-> December
		augend.constant.alias.bool, -- true <-> false
		augend.constant.alias.Bool, -- True <-> False
		logical_alias, -- && <-> ||
	},
})

require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	-- git signs on all lines (not just changed ones)
	current_line_blame = true,
	current_line_blame_opts = { virt_text_pos = "right_align" },
	-- speed up / debounce
	watch_gitdir = { interval = 1000, follow_files = true },
	signcolumn = true,
	signs_staged_enabled = true,
})

-- Setup snacks.nvim
require("snacks").setup({
	bigfile = { enabled = true },
	-- dashboard = { enabled = true },
	explorer = { enabled = false },
	indent = { enabled = true },
	input = { enabled = true }, -- nice UI for user input prompts (not commands)
	notifier = { enabled = true, timeout = 3000 },
	picker = {
		enabled = true,
		win = {
			list = { wo = { wrap = true, number = true } },
			preview = { wo = { wrap = true, number = true } },
		},
	},
	quickfile = { enabled = true }, -- load content before plugins
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true }, -- highlighting in status column
	words = { enabled = true }, -- jump between references under cursor with ]]
})

-- bufferline config
require("bufferline").setup({
	options = {
		mode = "buffers", -- "buffers" or "tabs"
		themable = true,
		numbers = "none",
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		diagnostics = "nvim_lsp",
		separator_style = "slant",
		show_buffer_close_icons = true,
		show_close_icon = true,
		always_show_bufferline = true,
		offsets = {
			{
				filetype = "neo-tree",
				text = "Neo-tree",
				highlight = "Directory",
				text_align = "left",
				separator = true,
			},
		},
	},
})

-- statusline config
require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			"mode",
			{
				"recording",
				cond = function()
					return vim.fn.reg_recording() ~= ""
				end,
			},
			{
				"debug",
				cond = function()
					return vim.o.verbosefile ~= ""
				end,
			},
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 2 }, "filesize" },
		lualine_x = {
			{
				"lsp",
				icon = "",
			},
			"encoding",
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})
-- sessions
require("persistence").setup({
	dir = vim.fn.stdpath("state") .. "/sessions/",
})
-- catppuccin
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = false,
})

local cmp = require("blink.cmp")
-- cmp.build():pwait()
cmp.setup({
	keymap = {
		preset = "default",
	},
})

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
-- keymaps
vim.g.mapleader = " "
-- neo-tree
vim.keymap.set({ "n", "v" }, "<leader>e", ":Neotree toggle=true <CR>")
-- german keyboard adjustments
vim.keymap.set({ "n", "v" }, "ä", "]", { remap = true, desc = "Alias for ]" })
vim.keymap.set({ "n", "v" }, "ää", "]]", { remap = true, desc = "Alias for ]" })
vim.keymap.set({ "n", "v" }, "ö", "[", { remap = true, desc = "Alias for [" })
vim.keymap.set({ "n", "v" }, "öö", "[[", { remap = true, desc = "Alias for [" })
vim.keymap.set("n", "<leader><tab>ä", "<leader><tab>[", { remap = true, desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>ö", "<leader><tab>]", { remap = true, desc = "Next Tab" })
-- search
vim.keymap.set("n", "ü", "/", { remap = true, desc = "Search" })
vim.keymap.set("n", "Ü", "?", { remap = true, desc = "Search" })
-- brackets
vim.keymap.set("n", "-", "%", { remap = true, desc = "Percent" })
-- windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
-- terminal
vim.keymap.set("n", "<leader>t", function()
	vim.cmd("botright split | terminal")
	vim.cmd("startinsert")
end, { desc = "Open terminal" })
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = 0 })
	end,
})
-- Picker
vim.keymap.set("n", "<leader><space>", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>,", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>ü", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Scratch Buffer" })
-- Notifications
vim.keymap.set("n", "<leader>n", function()
	Snacks.picker.notifications()
end, { desc = "Notification History" })
-- Diagnostics
vim.keymap.set("n", "<leader>d", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>D", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
-- git
vim.keymap.set("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git Status" })
-- LSP replace default behavior with pickers and preview
vim.keymap.set("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function()
	Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gai", function()
	Snacks.picker.lsp_incoming_calls()
end, { desc = "C[a]lls Incoming" })
vim.keymap.set("n", "gao", function()
	Snacks.picker.lsp_outgoing_calls()
end, { desc = "C[a]lls Outgoing" })
-- LSP Symbols
vim.keymap.set("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "LSP      Symbols" })
vim.keymap.set("n", "<leader>sS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })
-- Git
vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
-- Registers
vim.keymap.set("n", "<leader>p", function()
	Snacks.picker.registers()
end, { desc = "Registers" })
-- File Explorekr
-- vim.keymap.set("n", "<leader>e", function()
-- 	Snacks.explorer()
-- end, { desc = "File Explorer" })
-- Buffer
vim.keymap.set("n", "<delete>", function()
	Snacks.bufdelete()
end, { desc = "Close Buffer" })
-- flash nvim
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
-- commandline
vim.keymap.set("n", ":", "<cmd>FineCmdline<CR>", { noremap = true, desc = "Floating command line" })
-- bufferline
vim.keymap.set("n", "L", function()
	vim.cmd("bnext " .. vim.v.count1)
end, { desc = "Next buffer" })
vim.keymap.set("n", "H", function()
	vim.cmd("bprev " .. vim.v.count1)
end, { desc = "Previous buffer" })

-- window splits
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Split Horizontal" })
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split Vertical" })
-- sessions
vim.keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end)
---- Restore session for current directory
vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end)
-- update packages
vim.keymap.set("n", "<leader>uu", ":lua vim.pack.update()<CR>")
-- git hunks
gs = require("gitsigns")
vim.keymap.set("n", "]h", function()
	gs.nav_hunk("next")
end, { desc = "Next Hunk" })
vim.keymap.set("n", "[h", function()
	gs.nav_hunk("prev")
end, { desc = "Prev Hunk" })
-- surround
vim.keymap.set("n", "gsa", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding" })
vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding" })
vim.keymap.set("n", "gsr", "<Plug>(nvim-surround-change)", { desc = "Replace surrounding" })
-- dial
vim.keymap.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end, { desc = "Increment" })
vim.keymap.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end, { desc = "Decrement" })
vim.keymap.set("x", "<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end, { desc = "Increment" })
vim.keymap.set("x", "<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end, { desc = "Decrement" })
-- functions wrappers
vim.keymap.set("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd.nohlsearch()
	end
	return "<Ignore>"
end, { expr = true })
vim.keymap.set("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })
-- textobjects
local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "x", "o" }, "af", function()
	select.select("@function.outer")
end, { desc = "Select around function" })
vim.keymap.set({ "x", "o" }, "if", function()
	select.select("@function.inner")
end, { desc = "Select inside function" })
vim.keymap.set({ "x", "o" }, "ac", function()
	select.select("@class.outer")
end, { desc = "Select around class" })
vim.keymap.set({ "x", "o" }, "ic", function()
	select.select("@class.inner")
end, { desc = "Select inside class" })
vim.keymap.set({ "x", "o" }, "aa", function()
	select.select("@parameter.outer")
end, { desc = "Select around parameter" })
vim.keymap.set({ "x", "o" }, "ia", function()
	select.select("@parameter.inner")
end, { desc = "Select inside parameter" })
vim.keymap.set({ "x", "o" }, "al", function()
	select.select("@loop.outer")
end, { desc = "Select around loop" })
vim.keymap.set({ "x", "o" }, "il", function()
	select.select("@loop.inner")
end, { desc = "Select inside loop" })
vim.keymap.set({ "x", "o" }, "aT", function()
	select.select("@conditional.outer")
end, { desc = "Select around conditional" })
vim.keymap.set({ "x", "o" }, "iT", function()
	select.select("@conditional.inner")
end, { desc = "Select inside conditional" })
vim.keymap.set({ "x", "o" }, "ab", function()
	select.select("@block.outer")
end, { desc = "Select around block" })
vim.keymap.set({ "x", "o" }, "ib", function()
	select.select("@block.inner")
end, { desc = "Select inside block" })
vim.keymap.set({ "x", "o" }, "aC", function()
	select.select("@comment.outer")
end, { desc = "Select around comment" })
vim.keymap.set({ "x", "o" }, "iC", function()
	select.select("@comment.inner")
end, { desc = "Select inside comment" })

-- ---- move to next/prev object
vim.keymap.set({ "n", "x", "o" }, "]f", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "]F", function()
	move.goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Prev function start" })
vim.keymap.set({ "n", "x", "o" }, "[F", function()
	move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "Prev function end" })

vim.keymap.set({ "n", "x", "o" }, "]c", function()
	move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "]C", function()
	move.goto_next_end("@class.outer", "textobjects")
end, { desc = "Next class end" })
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Prev class start" })
vim.keymap.set({ "n", "x", "o" }, "[C", function()
	move.goto_previous_end("@class.outer", "textobjects")
end, { desc = "Prev class end" })

vim.keymap.set({ "n", "x", "o" }, "]a", function()
	move.goto_next_start("@parameter.inner", "textobjects")
end, { desc = "Next parameter" })
vim.keymap.set({ "n", "x", "o" }, "]A", function()
	move.goto_next_end("@parameter.inner", "textobjects")
end, { desc = "Next parameter end" })
vim.keymap.set({ "n", "x", "o" }, "[a", function()
	move.goto_previous_start("@parameter.inner", "textobjects")
end, { desc = "Prev parameter" })
vim.keymap.set({ "n", "x", "o" }, "[A", function()
	move.goto_previous_end("@parameter.inner", "textobjects")
end, { desc = "Prev parameter end" })
