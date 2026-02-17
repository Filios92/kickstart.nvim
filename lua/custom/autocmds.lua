-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local function augroup(name) return vim.api.nvim_create_augroup('user_' .. name, { clear = true }) end

if not vim.g.vscode then
  -- When editing a file, always jump to the last known cursor position.
  -- Don't do it when the position is invalid, when inside an event handler
  -- (happens when dropping a file on gvim) and for a commit message (it's
  -- likely a different one than last time).
  vim.api.nvim_create_autocmd('BufReadPost', {
    -- group = vim.g.user.event,
    callback = function(args)
      local valid_line = vim.fn.line [['"]] >= 1 and vim.fn.line [['"]] < vim.fn.line '$'
      local not_commit = vim.b[args.buf].filetype ~= 'commit'

      if valid_line and not_commit then vim.cmd [[normal! g`"]] end
    end,
  })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    callback = function()
      -- check if treesitter has parser
      if require('nvim-treesitter.parsers').has_parser() then
        -- use treesitter folding
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      else
        -- use alternative foldmethod
        vim.opt.foldmethod = 'syntax'
      end
    end,
  })

  -- Check if we need to reload the file when it changed
  vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup 'checktime',
    callback = function()
      if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
    end,
  })

  -- wrap and check for spell in text filetypes
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'wrap_spell',
    pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
  })

  -- resize splits if window got resized
  vim.api.nvim_create_autocmd({ 'VimResized' }, {
    group = augroup 'resize_splits',
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd 'tabdo wincmd ='
      vim.cmd('tabnext ' .. current_tab)
    end,
  })
  -- Auto create dir when saving a file
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    callback = function(event)
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'man_unlisted',
  pattern = { 'man' },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    -- 'DiffviewFiles',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})
