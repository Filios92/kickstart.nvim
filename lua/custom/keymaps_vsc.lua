local vscode = require 'vscode'

vim.g.clipboard = vim.g.vscode_clipboard

local function vscmap(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, function()
    vscode.call(rhs)
  end, { silent = true, noremap = true })
end

-- Remap folding keys
vscmap('n', 'zM', 'editor.foldAll')
vscmap('n', 'zR', 'editor.unfoldAll')
vscmap('n', 'zc', 'editor.fold')
vscmap('n', 'zC', 'editor.foldRecursively')
vscmap('n', 'zo', 'editor.unfold')
vscmap('n', 'zO', 'editor.unfoldRecursively')
vscmap('n', 'za', 'editor.toggleFold')

-- vscmap({ 'n', 'v' }, 'u', 'undo')
-- vscmap({ 'n', 'v' }, '<c-r>', 'redo')
--
--
--
vscmap({ 'n', 'v' }, '<leader>fs', 'editor.action.formatSelection')
vscmap({ 'n', 'v' }, '<leader>fd', 'editor.action.formatDocument')
vscmap('n', '<leader>gl', 'gitlens.showGraphPage')
vscmap('n', '<leader>gg', 'workbench.scm.focus')
vscmap('n', '<leader>e', 'workbench.view.explorer')
vscmap('n', '<leader><space>', 'workbench.action.showAllEditorsByMostRecentlyUsed')
vscmap({ 'n', 'v' }, '<leader>d', 'editor.action.showHover')
vscmap({ 'n', 'v' }, 'gr', 'editor.action.referenceSearch.trigger')
vscmap('n', 'gW', 'workbench.action.showAllSymbols')
vscmap('n', '<leader>sf', 'workbench.action.quickOpen', { desc = '[S]earch [F]iles' })

vim.keymap.set({ 'n', 'x', 'i' }, '<C-d>', function()
  require('vscode-multi-cursor').addSelectionToNextFindMatch()
end)
