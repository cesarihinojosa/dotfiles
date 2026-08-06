return {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    opts = {
        -- keep the cursor line rendered instead of revealing its raw source
        anti_conceal = { enabled = false },
    },
    init = function()
        vim.keymap.set('n', '<leader>mm', function()
            require('render-markdown.api').buf_toggle()
        end, { desc = 'Toggle raw markdown (this buffer)' })
    end,
}
