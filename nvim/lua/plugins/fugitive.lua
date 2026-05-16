return {
	"tpope/vim-fugitive",
	config = function()
		-- Git status
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
		vim.keymap.set("n", "<leader>ga", function()
			vim.cmd("Git add -A")
			print("Staged all files")
		end, { desc = "Git stage all files" })
		vim.keymap.set("n", "<leader>gA", function()
			vim.cmd("Git add %")
			print("Staged " .. vim.fn.expand("%:t"))
		end, { desc = "Git stage current file" })
		vim.keymap.set("n", "<leader>gc", function()
			vim.ui.input({ prompt = "Commit message: " }, function(msg)
				if not msg or msg == "" then
					return
				end
				vim.cmd('Git commit -m "' .. msg:gsub('"', '\\"') .. '"')
			end)
		end, { desc = "Git commit" })
		vim.keymap.set("n", "<leader>gP", function()
			vim.cmd("Git push")
		end, { desc = "Git push" })
		vim.keymap.set("n", "<leader>gl", function()
			vim.cmd("Git pull")
		end, { desc = "Git pull" })
		vim.keymap.set("n", "<leader>gp", function()
			vim.ui.input({ prompt = "Commit message: " }, function(msg)
				if not msg or msg == "" then
					return
				end
				vim.cmd("Git add -A")
				vim.cmd('Git commit -m "' .. msg:gsub('"', '\\"') .. '"')
				vim.cmd("Git push")
			end)
		end, { desc = "Git stage all + commit + push" })
		vim.keymap.set("n", "<leader>gb", function()
			vim.cmd("Git blame")
		end, { desc = "Git blame" })
		vim.keymap.set("n", "<leader>gd", function()
			vim.cmd("Git diff")
		end, { desc = "Git diff" })
		vim.keymap.set("n", "<leader>go", function()
			vim.cmd("Git log --oneline")
		end, { desc = "Git log (oneline)" })
	end,
}
