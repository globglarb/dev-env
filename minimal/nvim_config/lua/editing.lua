-- auto tags
require("nvim-ts-autotag").setup()
-- autopairs
require("nvim-autopairs").setup({})
-- neo-tree
require("neo-tree").setup({})
-- vim ui library version 2 needed for cmd line plugin
require("vim._core.ui2").enable({})
-- surround
require("nvim-surround").setup()
-- cmdline
require("tiny-cmdline").setup()

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
	signs_staged_enable = true,
})

require("diffview").setup({
	view = {
		default = { disable_diagnostics = true },
		merge_tool = {
			layout = "diff3_horizontal", -- or "diff3_vertical"
			disable_diagnostics = true, -- keep LSP noise out of merge buffers
		},
	},
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
				function()
					local reg = vim.fn.reg_recording()
					if reg == "" then
						return ""
					end
					return "recording @" .. reg
				end,
				cond = function()
					return vim.fn.reg_recording() ~= ""
				end,
			},
			-- {
			-- 	"debug",
			-- 	cond = function()
			-- 		return vim.o.verbosefile ~= ""
			-- 	end,
			-- },
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 2 }, "filesize" },
		lualine_x = {
			{
				"lsp_status",
				icon = " ",
				symbols = {
					spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					done = "✓",
					separator = " ",
				},
				ignore_lsp = {}, -- e.g. { "null-ls" } to skip certain clients
				show_name = true, -- false = only show spinner/check, not the name
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
	-- default is straight line
	lsp_styles = {
		underlines = {
			errors = { "undercurl" },
			warnings = { "undercurl" },
			information = { "undercurl" },
			hints = { "undercurl" },
			ok = { "undercurl" },
		},
	},
})

local cmp = require("blink.cmp")
-- cmp.build():pwait()
cmp.setup({
	keymap = {
		preset = "default",
	},
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = vim.fn.nr2char(0xea87), -- cod-error
			[vim.diagnostic.severity.WARN] = vim.fn.nr2char(0xea6c), -- cod-warning (triangle + !)
			[vim.diagnostic.severity.INFO] = vim.fn.nr2char(0xea74), -- cod-info
			[vim.diagnostic.severity.HINT] = vim.fn.nr2char(0xea61), -- cod-lightbulb
		},
	},
})
