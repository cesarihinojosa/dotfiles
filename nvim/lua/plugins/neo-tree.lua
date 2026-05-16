return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
        require("neo-tree").setup({
            default_component_configs = {
                modified = {
                    symbol = " ●",
                    highlight = "NeoTreeModified",
                },
            },
            window = {
                mappings = {
                    ["Y"] = function(state)
                        local node = state.tree:get_node()
                        local relative = vim.fn.fnamemodify(node:get_id(), ":.")
                        vim.fn.setreg("+", relative)
                        vim.notify("Copied: " .. relative)
                    end,
                },
            },
            filesystem = {
                use_libuv_file_watcher = true,
            },
            buffers = {
                follow_current_file = { enabled = true },
                show_unloaded = true,
            },
            git_status = {
                window = {
                    position = "float",
                },
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function()
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
            },
        })
        vim.keymap.set('n', '<leader>fs', ':Neotree<CR>', { desc = "File explorer (Neo-tree)" })
    end
}
