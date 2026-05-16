return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.goimports,
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })

		local go_format = vim.api.nvim_create_augroup("GoFormatOnSave", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = go_format,
			pattern = "*.go",
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
}
