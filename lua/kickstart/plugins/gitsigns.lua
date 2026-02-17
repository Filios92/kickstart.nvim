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
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'reset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'preview hunk' })
        map('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })
        -- map('n', '<leader>hb', gitsigns.blame_line, { desc = '[b]lame line' })
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'blame line' })
        map('n', '<leader>hB', gitsigns.blame, { desc = 'Blame buffer' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'diff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'Diff against last commit' })
        -- map('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = '[D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },

  {
    'sindrets/diffview.nvim',
    cond = not vim.g.vscode,
    -- opts = {} ,
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        keymaps = {
          file_panel = {
            { 'n', 'q', '<Cmd>DiffviewClose<CR>', { desc = 'Close diff view' } },
          },
          file_history_panel = {
            { 'n', 'q', '<Cmd>DiffviewClose<CR>', { desc = 'Close' } },
          },
        },
      }
      vim.keymap.set('n', '<leader>D', '<Cmd>DiffviewOpen<CR>', { desc = 'Diff: git status' })
      -- File history views
      vim.keymap.set('n', '<leader>gv', '<Cmd>DiffviewFileHistory<CR>', { desc = 'Diff: repo history' })
      vim.keymap.set('n', '<leader>gV', '<Cmd>DiffviewFileHistory %<CR>', { desc = 'Diff: current file history' })
      -- Visual mode: history of selected lines
      vim.keymap.set('v', '<leader>gv', ":'<,'>DiffviewFileHistory<CR>", { desc = 'Diff: selection history' })
      -- Compare with revisions (prompts)
      vim.keymap.set('n', '<leader>gc', function()
        vim.ui.input({ prompt = 'Compare revision (ex. main, HEAD~5, main..HEAD): ' }, function(refs)
          if refs and refs:match '%S' then vim.cmd(('DiffviewOpen %s'):format(refs)) end
        end)
      end, { desc = 'Diff: compare revisions' })

      vim.keymap.set('n', '<leader>gC', function()
        vim.ui.input({ prompt = 'File history range (ex. HEAD~1, main..HEAD): ' }, function(range)
          if range and range:match '%S' then vim.cmd(('DiffviewFileHistory --range=%s %%'):format(range)) end
        end)
      end, { desc = 'Diff: file history with range' })

      -- Compare two arbitrary files
      vim.keymap.set('n', '<leader>g2', function()
        vim.ui.input({ prompt = 'First file: ' }, function(file1)
          if not file1 or not file1:match '%S' then return end
          vim.ui.input({ prompt = 'Second file: ' }, function(file2)
            if file2 and file2:match '%S' then vim.cmd(('tabnew | e %s | diffthis | vsplit %s | diffthis'):format(file1, file2)) end
          end)
        end)
      end, { desc = 'Diff: Compare 2 files' })
    end,
  },
}
