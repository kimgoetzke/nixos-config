-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Bufferline tab navigation
vim.keymap.set('n', '<C-S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Cycle to next buffer' })
vim.keymap.set('n', '<C-S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Cycle to previous buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close all other buffers' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Toggle pinned status' })

-- Run formatter
-- Run the appropriate formatter for the current file type
vim.keymap.set('n', '<leader>lf', function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    vim.cmd('lua vim.lsp.buf.formatting()')
  elseif filetype == 'rust' then
    vim.cmd('RustFmt')
  else
    print('No formatter configured for this file type')
  end
end, { desc = 'Format the current buffer based on file type' })