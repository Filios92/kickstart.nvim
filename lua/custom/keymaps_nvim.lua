local function map1(mode, keys, cmd, opts)
  opts = opts or { silent = true, noremap = true }
  vim.keymap.set(mode, keys, cmd, opts)
end

-- move lines up and down
map1('n', '<A-j>', ':m .+1<CR>==')
map1('n', '<A-k>', ':m .-2<CR>==')
map1('v', '<A-j>', ":m '>+1<CR>gv=gv")
map1('v', '<A-k>', ":m '<-2<CR>gv=gv")

-- Undo with Ctrl-z in insert mode
map1('i', '<C-z>', '<C-O>u')

-- Esc from insert
map1('i', 'jkj', '<esc>')

-- Wrap toggle
map1('n', '<A-z>', '<cmd>:set wrap!<cr>')

-- Comment with Ctrl-/ (some terminals do Ctrl-_)
-- map1({ 'n' }, 'gcc', 'my<cmd>gcc<cr>`y', { remap = true })
map1({ 'n' }, '<C-_>', ':normal gcc<Cr>')
map1({ 'i' }, '<C-_>', '<C-o>:normal gcc<cr>')
map1('x', '<C-_>', 'gcgv', { remap = true, silent = true })

-- In insert move shift with arrows will move
local function map_arrows_insert(key, key2)
  map1('i', '<s-' .. key .. '>', '<c-o>v<c-g>')
  map1('s', '<s-' .. key .. '>', '<c-g>' .. key2 .. '<c-g>')
end
map_arrows_insert('left', 'h')
map_arrows_insert('right', 'l')
map_arrows_insert('up', 'k')
map_arrows_insert('down', 'j')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<A-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-A-right>', '<C-w>v', { desc = 'Split right' })
vim.keymap.set('n', '<C-A-down>', '<C-w><C-S>', { desc = 'Split below' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set('n', '<A-->', '<C-o>', { desc = 'Go back' })
vim.keymap.set('n', '<A-=>', '<C-i>', { desc = 'Go forward' })
