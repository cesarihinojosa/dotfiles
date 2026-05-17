vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
vim.opt.autoindent = true   -- Copy indent from current line when starting new line
vim.opt.smartindent = true  -- Smart autoindenting for C-like languages
vim.opt.expandtab = true    -- Convert tabs to spaces
vim.opt.shiftwidth = 4      -- Number of spaces for indentation
vim.opt.tabstop = 4         -- Number of spaces a tab counts for
vim.opt.softtabstop = 4     -- Number of spaces for <Tab> in insert mode
vim.opt.number = true         -- Shows absolute line number on current line
vim.opt.relativenumber = true -- Shows relative numbers on other lines
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'

vim.keymap.set('n', '<leader>t', function()
  local term_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' and vim.api.nvim_buf_is_valid(buf) then
      term_buf = buf
      break
    end
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if term_buf and vim.api.nvim_win_get_buf(win) == term_buf then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  vim.cmd('botright 15split')
  if term_buf then
    vim.api.nvim_set_current_buf(term_buf)
  else
    vim.cmd('terminal')
  end
  vim.cmd('startinsert')
end, { desc = 'Toggle terminal' })

vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
