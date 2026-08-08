-- LSP and tool configs
require("mason").setup()

-- mason names, mapped to lspconfig names and configuration
require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP servers (same as the LazyVim example stack)
		"pyright", -- Python
		"typescript-language-server", -- TS/JS (ts_ls)
		"json-lsp", -- JSON (jsonls), allows for schemas to be added to the config
		"bash-language-server", -- bash (bashls)
		"dockerfile-language-server", -- Dockerfile (dockerls)
		"yaml-language-server", -- YAML / docker-compose (yamlls)

		-- formatter
		"stylua",
		"shfmt",
		"yamlfmt",
		"prettierd", -- markdown

		-- Linters from the LazyVim example
		"shellcheck",
		"ruff", -- python
		"hadolint", --docker

		-- DAP typescript
		"js-debug-adapter",
		"debugpy",
	},
	auto_update = false,
	run_on_start = true,
})

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

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
			},
		},
	},
})

vim.lsp.enable({ "pyright", "ts_ls", "jsonls", "bashls", "dockerls", "yamlls" })

-- formatters
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		yaml = { "yamlfmt" },
		markdown = { "prettierd" },
	},
	formatters = {
		prettierd = {
			prepend_args = { "--prose-wrap", "preserve" },
		},
	},
	format_on_save = { timeout_ms = 500, lsp_format = "never" },
	undojoin = true,
})

-- linters
require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	python = { "ruff" },
	dockerfile = { "hadolint" },
}

-- lint when reading / writing
vim.api.nvim_create_autocmd({ "BufWritePost", "FileType" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- DAP configuration
local dap = require("dap")
local dapui = require("dapui")

require("dapui").setup({
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.25 },
				{ id = "breakpoints", size = 0.25 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "console", size = 0.5 },
				{ id = "repl", size = 0.5 },
			},
			size = 20,
			position = "bottom",
		},
	},
})

require("nvim-dap-virtual-text").setup({
	enabled = true,
	virt_text_pos = "eol",
})

require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

-- auto open/close the UI when a debug session starts/ends
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- colors for the signs (global highlight groups)
vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#e78284" }) -- red
vim.api.nvim_set_hl(0, "DapBreakpointConditionSign", { fg = "#e5c890" }) -- yellow
vim.api.nvim_set_hl(0, "DapLogPointSign", { fg = "#99d1db" }) -- cyan
vim.api.nvim_set_hl(0, "DapStoppedSign", { fg = "#a6d189" }) -- green

-- glyphs (these are nerd-font friendly; swap for plain ASCII if you prefer)
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpointSign" })
vim.fn.sign_define("DapBreakpointCondition", {
	text = "◉",
	texthl = "DapBreakpointConditionSign",
})
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPointSign" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStoppedSign", linehl = "debugPC" })

-- needed for pinning of function on top etc., other functionality, syntax parsing
require("nvim-treesitter").install({
	"python",
	"typescript",
	"html",
	"javascript",
	"svelte",
	"xml",
	"bash",
	"dockerfile",
})

-- enable treesitter highlighting for installed parsers
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = { enable = true },
	move = { enable = true },
})
