return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()
		require("dap-go").setup()

		-- Auto open/close the debug UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		local function map(keys, fn, desc)
			vim.keymap.set("n", keys, fn, { desc = desc })
		end

		map("<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
		map("<leader>dc", dap.continue, "Continue / start debug")
		map("<leader>di", dap.step_into, "Step into")
		map("<leader>do", dap.step_over, "Step over")
		map("<leader>dO", dap.step_out, "Step out")
		map("<leader>dr", dap.repl.open, "Open REPL")
		map("<leader>du", dapui.toggle, "Toggle debug UI")
		map("<leader>dt", require("dap-go").debug_test, "Debug nearest Go test")
	end,
}
