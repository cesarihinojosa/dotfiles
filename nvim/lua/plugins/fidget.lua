return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		progress = {
			suppress_on_insert = true,
			ignore_done_already = true,
			display = {
				done_ttl = 2,
				render_limit = 3,
			},
		},
		notification = {
			window = {
				winblend = 0,
				border = "none",
			},
		},
	},
}
