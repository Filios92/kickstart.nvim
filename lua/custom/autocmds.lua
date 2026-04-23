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
      if vim.o.filetype == 'markdown' and vim.api.nvim_win_get_config(0).zindex then return end
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

  -- Auto-command to customize chat buffer behavior
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      vim.opt_local.conceallevel = 0
    end,
  })

  -- Snacks toggle
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
      Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
      Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
      Snacks.toggle.diagnostics():map '<leader>udD'
      Snacks.toggle.line_number():map '<leader>ul'
      Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }):map '<leader>uc'
      Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):map '<leader>uA'
      Snacks.toggle.treesitter():map '<leader>uT'
      Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
      Snacks.toggle.dim():map '<leader>uD'
      Snacks.toggle.animate():map '<leader>ua'
      Snacks.toggle.indent():map '<leader>ug'
      Snacks.toggle.scroll():map '<leader>uS'
      Snacks.toggle.profiler():map '<leader>dpp'
      Snacks.toggle.profiler_highlights():map '<leader>dph'
      Snacks.toggle.zoom():map('<leader>wm'):map '<leader>uZ'
      Snacks.toggle.zen():map '<leader>uz'
      Snacks.toggle
        .new({
          id = 'autoformat_buffer',
          name = 'Autoformat for buffer',
          get = function() return not vim.b.disable_autoformat end,
          set = function() vim.b.disable_autoformat = not vim.b.disable_autoformat end,
        })
        :map '<leader>ufb'
      Snacks.toggle
        .new({
          id = 'autoformat',
          name = 'Autoformat',
          get = function() return not vim.g.disable_autoformat end,
          set = function() vim.g.disable_autoformat = not vim.g.disable_autoformat end,
        })
        :map '<leader>ufg'
      Snacks.toggle
        .new({
          id = 'autoformat_modified',
          name = 'Autoformat modified',
          get = function() return vim.g.autoformat_modified end,
          set = function() vim.g.autoformat_modified = not vim.g.autoformat_modified end,
        })
        :map '<leader>ufm'
      Snacks.toggle
        .new({
          id = 'diagnostics_vtext',
          name = 'Diagnostics V Text',
          get = function() return vim.diagnostic.config().virtual_text ~= false end,
          set = function(state) vim.diagnostic.config { virtual_text = state and Diagnostic_config_vtext or false } end,
        })
        :map '<leader>udt'
      Snacks.toggle
        .new({
          id = 'diagnostics_vlines',
          name = 'Diagnostics V Lines',
          get = function() return vim.diagnostic.config().virtual_lines ~= false end,
          set = function(state) vim.diagnostic.config { virtual_lines = state and Diagnostic_config_vlines or false } end,
        })
        :map '<leader>udl'

      require('which-key').add { { '<leader>uf', group = 'Autoformat' } }
      vim.g.autoformat_modified = true
    end,
  })

  if os.getenv 'TMUX' then
    --- wraps message with tmux prefix so that the underlying terminal can interpret it correctly
    --- needs 'set-option -g allow-passthrough on' in tmux config
    ---@param content string
    ---@return string
    -- local function wrap_tmux(content) return string.format('\27Ptmux;\27%s\27\\', content) end
    -- local function wrap_tmux(content) return string.format('\27Ptmux;\27%s\27\\', content) end
    -- local function wrap_tmux(content) return '\27Ptmux;\27' .. content .. '\27\\' end
    local function wrap_tmux(content) return '\27Ptmux;\27' .. content .. '\27\\' end
    -- local function wrap_tmux(content) return string.format('\033Ptmux;\033%s\033\\', content) end

    local original_ui_send = vim.api.nvim_ui_send

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_ui_send =
      ---@param content string
      function(content)
        -- vim.print(content)
        -- vim.print(wrap_tmux(content))
        original_ui_send(wrap_tmux(content))
      end
  end

  vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ev)
      -- vim.print(ev.data)
      local value = ev.data.params.value
      vim.api.nvim_echo({ { value.message or 'done' } }, false, {
        id = 'lsp.' .. ev.data.client_id,
        kind = 'progress',
        source = 'vim.lsp',
        title = value.title,
        status = value.kind ~= 'end' and 'running' or 'success',
        percent = value.percentage,
      })
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
