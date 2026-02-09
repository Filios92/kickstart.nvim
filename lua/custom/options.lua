-- NOTE: from kickstart
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [ Indentation ]
vim.opt.tabstop = 4 -- Tab width
vim.opt.shiftwidth = 4 -- Indent width
-- vim.o.softtabstop = 4 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
-- opt.smartindent = true -- Smart auto-indenting
-- opt.autoindent = true -- Copy indent from current line

if not vim.g.vscode then
  vim.g.have_nerd_font = true -- if Nerd Font installed and selected in terminal

  -- [ Cursor ]
  vim.o.number = true -- Make line numbers default
  vim.o.relativenumber = true -- Relative
  vim.o.cursorline = true -- Show which line your cursor is on
  vim.o.wrap = false -- Dont wrap at startup
  vim.o.scrolloff = 10 -- Kepp lines above and below the cursor.
  vim.o.sidescrolloff = 8 -- Kepp lines left and right the cursor.

  -- [ File handling ]
  -- vim.opt.backup = false -- Don't create backup files
  -- vim.opt.writebackup = false -- Don't create backup before writing
  vim.opt.swapfile = false -- Don't create swap files
  vim.o.undofile = true -- Save undo history

  -- Sets how neovim will display certain whitespace characters in the editor.
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', extends = '↦' }
  vim.o.showbreak = '↳'

  vim.o.confirm = true -- Confirm dialog on unsaved changes

  -- [ Folding settings ]
  vim.opt.foldenable = true
  vim.opt.foldlevel = 99 -- start with all open
end

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { silent = true, noremap = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>Y', '<cmd>let @+=@"<cr>', { silent = true, noremap = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { silent = true, noremap = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>P', '<cmd>let @"=@+<cr>', { silent = true, noremap = true })

-- [ Search settings ]
vim.o.ignorecase = true -- Case insensitive search, unless \C or more capital letters
vim.o.smartcase = true -- Case sensitive if uppercase in search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlights on <Esc> in normal

-- [ Visual settings ]
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.showmode = vim.g.vscode and true or false -- Don't show the mode, already in the status line
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
-- vim.o.ttimeoutlen = 300 -- Key code timeout
vim.o.linebreak = true -- Break lines at nice words
vim.o.breakindent = true -- Enable break indent
vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.splitright = true
vim.o.splitbelow = true
-- vim.o.splitkeep = 'screen'

-- [ Performance settings ]
vim.o.updatetime = 250 -- Decrease update time
vim.o.synmaxcol = 300 -- Syntax hl column limit, prevent freeze on minified files
-- vim.o.redrawtime = 10000 -- Over this -> disable hlsearch, syntax etc.
-- vim.o.maxmempattern = 20000 -- Memory limit as above
