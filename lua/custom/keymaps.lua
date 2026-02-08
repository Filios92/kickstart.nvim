local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

-- In visual better indenting
map('v', '<tab>', '>gv', opts)
map('v', '<S-tab>', '<gv', opts)
map('v', '>', '>gv', opts)
map('v', '<', '<gv', opts)

-- Better paste (doesn't replace clipboard with deleted text)
map('v', 'p', '"_dP', opts)

-- mini.surround add nice block
map('v', 'sb', 'sa{gv=', { silent = true, remap = true })

-- Smart search navigation (n always goes forward, N always backward)
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

if vim.g.vscode then
  require 'custom.keymaps_vsc'
else
  require 'custom.keymaps_nvim'
end
