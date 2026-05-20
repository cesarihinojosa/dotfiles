return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gp", function()
			vim.ui.input({ prompt = "Commit message: " }, function(msg)
				if not msg or msg == "" then
					return
				end
				vim.cmd("Git add -A")
				vim.cmd('Git commit -m "' .. msg:gsub('"', '\\"') .. '"')
				vim.cmd("Git push")
			end)
		end)
	end,
}
