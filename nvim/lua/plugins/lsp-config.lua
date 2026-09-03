return {
	{
		"mason-org/mason.nvim",
		opts = {},
		config = function(_, opts)
			require("mason").setup(opts)
			-- mason.nvim core has no ensure_installed for non-LSP tools, so install them manually
			local registry = require("mason-registry")
			local function ensure(pkg)
				if not registry.is_installed(pkg) then
					registry.get_package(pkg):install()
				end
			end
			registry.refresh(function()
				ensure("goimports")
				ensure("delve")
			end)
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
			ensure_installed = { "gopls", "gitlab_ci_ls", "ruby_lsp", "pyright" },
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			-- gitlab-ci-ls attaches to the "yaml.gitlab" filetype only
			vim.filetype.add({
				pattern = {
					["%.gitlab%-ci%.yml"] = "yaml.gitlab",
					["%.gitlab%-ci%.yaml"] = "yaml.gitlab",
					[".*/%.gitlab/.*%.yml"] = "yaml.gitlab",
					[".*/%.gitlab/.*%.yaml"] = "yaml.gitlab",
				},
			})
			-- Reduce delay for diagnostic updates
			vim.opt.updatetime = 250

			-- Configure how diagnostics are displayed
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Customize diagnostic signs in the gutter
			local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- LSP keymaps and diagnostic trigger on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- Navigation
					local function lsp_opts(desc)
						return vim.tbl_extend("force", opts, { desc = desc })
					end

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, lsp_opts("Go to definition"))
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lsp_opts("Go to declaration"))
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lsp_opts("Go to implementation"))
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, lsp_opts("Go to type definition"))
					vim.keymap.set("n", "gr", vim.lsp.buf.references, lsp_opts("Find references"))
					vim.keymap.set("n", "K", vim.lsp.buf.hover, lsp_opts("Hover docs"))
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, lsp_opts("Signature help"))
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, lsp_opts("Signature help"))

					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, lsp_opts("Code action"))
					vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, lsp_opts("Code action (visual)"))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, lsp_opts("Rename symbol"))
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, lsp_opts("Format buffer"))

					vim.keymap.set("n", "<leader>e", function()
						local diag = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
						if #diag > 0 then
							vim.fn.setreg("+", diag[1].message)
						end
						vim.diagnostic.open_float()
					end, lsp_opts("Show diagnostic + copy"))
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, lsp_opts("Previous diagnostic"))
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, lsp_opts("Next diagnostic"))
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, lsp_opts("Diagnostics to loclist"))

					-- Force diagnostics to show immediately after LSP attaches
					vim.defer_fn(function()
						vim.diagnostic.enable(true, { bufnr = ev.buf })
					end, 100)
				end,
			})
		end,
	},
}
