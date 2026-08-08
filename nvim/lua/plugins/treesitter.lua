local ensure_installed = {
	"bash",
	"c",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"git_config",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"ruby",
	"rust",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()

		local installed = {}
		for _, lang in ipairs(require("nvim-treesitter.config").get_installed()) do
			installed[lang] = true
		end
		local missing = vim.tbl_filter(function(lang)
			return not installed[lang]
		end, ensure_installed)
		if #missing > 0 then
			require("nvim-treesitter").install(missing)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
				if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
					return
				end
				if vim.treesitter.query.get(lang, "indents") then
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
