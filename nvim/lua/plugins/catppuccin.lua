return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = true,
	-- Not applied by default; gruvbox-material is active. Switch with :colorscheme catppuccin
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				alpha = true,
				cmp = true,
				dap = true,
				dap_ui = true,
				fidget = true,
				gitsigns = true,
				markdown = true,
				mason = true,
				neotree = true,
				telescope = { enabled = true },
				treesitter = true,
				which_key = true,
				native_lsp = { enabled = true },
			},
		})
	end,
}
