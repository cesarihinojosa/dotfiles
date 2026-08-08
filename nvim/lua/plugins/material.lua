return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	init = function()
		vim.g.gruvbox_material_enable_italic = true
		vim.g.gruvbox_material_transparent_background = 1
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "gruvbox-material",
			callback = function()
				vim.api.nvim_set_hl(0, "@comment.todo", { fg = "#d8a657", bold = true })
				vim.api.nvim_set_hl(0, "Todo", { fg = "#d8a657", bold = true })
			end,
		})
	end,
	config = function()
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
