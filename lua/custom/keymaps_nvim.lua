local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ═══════════════════════════════════════════════════════════
-- BUFFER NAVIGATION (think browser tabs)
-- ═══════════════════════════════════════════════════════════
-- -- Tab/Shift-Tab: Like browser tabs, feels natural
-- map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
-- map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
--
-- -- Alternative buffer switching (vim-style)
-- map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- ═══════════════════════════════════════════════════════════
-- WINDOW MANAGEMENT (splitting and navigation)
-- ═══════════════════════════════════════════════════════════
--  Use CTRL+<hjkl> to switch between windows, :h wincmd
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to the upper window' })
map('n', '<A-left>', '<C-w><C-h>', { desc = 'Go to the left window' })
map('n', '<A-right>', '<C-w><C-l>', { desc = 'Go to the right window' })
map('n', '<A-down>', '<C-w><C-j>', { desc = 'Go to the lower window' })
map('n', '<A-up>', '<C-w><C-k>', { desc = 'Go to the upper window' })

-- Resize windows with Ctrl+Shift+arrows (macOS friendly)
-- map("n", "<C-S-Up>", "<cmd>resize +5<CR>", opts)
-- map("n", "<C-S-Down>", "<cmd>resize -5<CR>", opts)
-- map("n", "<C-S-Left>", "<cmd>vertical resize -5<CR>", opts)
-- map("n", "<C-S-Right>", "<cmd>vertical resize +5<CR>", opts)

-- Splitting
map('n', '<C-A-right>', '<C-w>v', { desc = 'Split right' })
map('n', '<C-A-down>', '<C-w><C-S>', { desc = 'Split below' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- map("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- map("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- map("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- map("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- ═══════════════════════════════════════════════════════════
-- SMART LINE MOVEMENT (the VSCode experience)
-- ═══════════════════════════════════════════════════════════
-- Smart j/k: moves by visual lines when no count, real lines with count
-- map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines up/down (Alt+j/k like VSCode)
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- ═══════════════════════════════════════════════════════════
-- SEARCH & NAVIGATION (ergonomic improvements)
-- ═══════════════════════════════════════════════════════════
-- Better line start/end (more comfortable than $ and ^)
-- map('n', 'gl', '$', { desc = 'Go to end of line' })
-- map('n', 'gh', '^', { desc = 'Go to start of line' })
-- map('n', '<A-h>', '^', { desc = 'Go to start of line', silent = true })
-- map('n', '<A-l>', '$', { desc = 'Go to end of line', silent = true })

-- Select all content
-- map('n', '==', 'gg<S-v>G')
map('n', '<C-a>', 'ggVG', { noremap = true, silent = true, desc = 'Select all' })
map('i', '<C-a>', '<esc>gg<S-v>G')

-- Move back and forth
map('n', '<A-->', '<C-o>', { desc = 'Go back' })
map('n', '<A-=>', '<C-i>', { desc = 'Go forward' })

-- Esc from insert
map('i', 'jkj', '<esc>', opts)

-- Wrap toggle
map('n', '<A-z>', '<cmd>:set wrap!<cr>', opts)

-- ═══════════════════════════════════════════════════════════
-- SMART TEXT EDITING
-- ═══════════════════════════════════════════════════════════
-- Smart undo break-points (create undo points at logical stops)
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Undo with Ctrl-z in insert mode
map('i', '<C-z>', '<C-O>u', opts)

-- Comment with Ctrl-/ (some terminals do Ctrl-_)
-- map({ 'n' }, 'gcc', 'my<cmd>gcc<cr>`y', { remap = true })
map({ 'n' }, '<C-_>', ':normal gcc<Cr>', opts)
map({ 'i' }, '<C-_>', '<C-o>:normal gcc<cr>', opts)
map('x', '<C-_>', 'gcgv', { remap = true, silent = true })

-- In insert move shift with arrows will move
local function map_arrows_insert(key, key2)
  map('i', '<s-' .. key .. '>', '<c-o>v<c-g>', opts)
  map('s', '<s-' .. key .. '>', '<c-g>' .. key2 .. '<c-g>', opts)
end
map_arrows_insert('left', 'h')
map_arrows_insert('right', 'l')
map_arrows_insert('up', 'k')
map_arrows_insert('down', 'j')

-- ═══════════════════════════════════════════════════════════
-- FILE OPERATIONS
-- ═══════════════════════════════════════════════════════════
-- Save file (works in all modes)
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- Create new file
-- map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- Quit operations
map('n', '<leader>qa', '<cmd>qa<cr>', { desc = 'Quit All' })
map('n', '<leader>qq', '<cmd>q<cr>', { desc = 'Quit' })

-- ═══════════════════════════════════════════════════════════
-- DEVELOPMENT TOOLS
-- ═══════════════════════════════════════════════════════════
-- Diagnostic keymaps
-- map('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostic' })

-- Quickfix and location lists
map('n', '<leader>xl', function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = 'Location List' })

map('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = 'Quickfix List' })

-- Inspection tools (useful for debugging highlights and treesitter)
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
map('n', '<leader>uI', '<cmd>InspectTree<cr>', { desc = 'Inspect Tree' })

-- ═══════════════════════════════════════════════════════════
-- TERMINAL INTEGRATION
-- ═══════════════════════════════════════════════════════════
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- ═══════════════════════════════════════════════════════════
-- TAB MANAGEMENT (when you need multiple workspaces)
-- ═══════════════════════════════════════════════════════════
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
