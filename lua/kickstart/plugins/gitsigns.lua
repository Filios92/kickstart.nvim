-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        local next_hunk = function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end

        local prev_hunk = function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end

        -- Navigation
        map('n', ']c', next_hunk, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', prev_hunk, { desc = 'Jump to previous git [c]hange' })

        map({ 'n', 'i' }, '<C-J>', next_hunk, { desc = 'Jump to next git [c]hange' })
        map({ 'n', 'i' }, '<C-K>', prev_hunk, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = '[u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
        map('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = '[P]review hunk inline' })
        -- map('n', '<leader>hb', gitsigns.blame_line, { desc = '[b]lame line' })
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = '[b]lame line' })
        map('n', '<leader>hB', gitsigns.blame, { desc = 'Blame buffer' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = '[d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = '[D]iff against last commit' })
        -- map('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = '[D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },

  -- { 'sindrets/diffview.nvim', cond = not vim.g.vscode, opts = {} },
}
