return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = { "lua", "vim", "python", "javascript", "rust", "c", "cpp", "zig" },
        highlight = { enable = true },
        indent = { enable = true },
    }
}
