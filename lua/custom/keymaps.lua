--  https://github.com/vscode-neovim/vscode-neovim/issues/58
-- vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = false, silent = true })
-- vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = false, silent = true })
-- THIS: to properly support 'specific' vscode handling - jump over fold and aligned number handling
-- https://www.reddit.com/r/neovim/comments/gjhhry/neovim_syntax_for_expr_keybinding/
-- vim.api.nvim_set_keymap('n', 'j', "v:count ? 'j' : 'gj'", { noremap = false, silent = true, expr = true })
-- vim.api.nvim_set_keymap('n', 'k', "v:count ? 'k' : 'gk'", { noremap = false, silent = true, expr = true })

local function delete_to_black_hole(cmds)
  for _, cmd in pairs(cmds) do
    vim.keymap.set({ 'n', 'v' }, cmd, '"_' .. cmd, { silent = true, noremap = true })
  end
end
delete_to_black_hole { 'c', 'C', 'x', 'X' }
-- map D to d
-- vim.keymap.set({ 'n', 'v' }, 'D', 'd', { silent = true, noremap = true })

vim.keymap.set('v', 'p', '"_dP', { silent = true, noremap = true })

-- In visual better indenting
vim.keymap.set('v', '<tab>', '>gv', { silent = true, noremap = true })
vim.keymap.set('v', '<S-tab>', '<gv', { silent = true, noremap = true })
vim.keymap.set('v', '>', '>gv', { silent = true, noremap = true })
vim.keymap.set('v', '<', '<gv', { silent = true, noremap = true })

-- mini.surround add nice block
vim.keymap.set('v', 'sb', 'sa{gv=', { silent = true, remap = true })

if vim.g.vscode then
  require 'custom.keymaps_vsc'
else
  require 'custom.keymaps_nvim'
end
