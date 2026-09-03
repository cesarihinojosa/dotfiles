return {
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local function fix_selection_hl()
                vim.api.nvim_set_hl(0, 'TelescopeSelection', { link = 'CursorLine' })
                vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { link = 'CursorLine' })
                vim.api.nvim_set_hl(0, 'TelescopeMultiSelection', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'TelescopeMultiIcon', { link = 'Normal' })
            end
            fix_selection_hl()
            vim.api.nvim_create_autocmd('ColorScheme', { callback = fix_selection_hl })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>fh', function()
                builtin.find_files({ hidden = true, no_ignore = true, file_ignore_patterns = { "%.git/" } })
            end, { desc = 'Telescope find files (hidden files)' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fgh', function()
                builtin.live_grep({ additional_args = { "--hidden", "--glob", "!.git/" } })
            end, { desc = 'Telescope live grep (hidden files)' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Telescope resume' })
        end
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            -- This is your opts table
            require("telescope").setup {
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown {
                    -- even more opts
                  }

                  -- pseudo code / specification for writing custom displays, like the one
                  -- for "codeactions"
                  -- specific_opts = {
                  --   [kind] = {
                  --     make_indexed = function(items) -> indexed_items, width,
                  --     make_displayer = function(widths) -> displayer
                  --     make_display = function(displayer) -> function(e)
                  --     make_ordinal = function(e) -> string
                  --   },
                  --   -- for example to disable the custom builtin "codeactions" display
                  --      do the following
                  --   codeactions = false,
                  -- }
                }
              }
            }
            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end
    }
}
