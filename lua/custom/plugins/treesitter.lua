local old_master_version = false

if not vim.g.vscode then
  if old_master_version then
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
  else
    -- vim.wo.foldmethod = 'expr'
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return old_master_version
    and { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      cond = not vim.g.vscode,
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      branch = 'master',
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'go', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
          -- disable = { 'tmux' },
        },
        indent = { enable = false, disable = { 'ruby' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<A-o>',
            node_incremental = '<A-o>',
            scope_incremental = '<A-O>',
            node_decremental = '<A-i>',
          },
        },
      },
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    }
  or {
    {
      'nvim-treesitter/nvim-treesitter',
      cond = not vim.g.vscode,
      -- build = ':TSUpdate',
      -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      branch = 'main',
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      config = function()
        local filetypes = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'go', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
        -- require('nvim-treesitter').setup {}
        local t = require 'nvim-treesitter'
        require('nvim-treesitter').install(filetypes)
        vim.api.nvim_create_autocmd('FileType', {
          pattern = filetypes,
          callback = function()
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.treesitter.start()
          end,
        })
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      init = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
        vim.g.no_plugin_maps = true

        -- Or, disable per filetype (add as you like)
        -- vim.g.no_python_maps = true
        -- vim.g.no_ruby_maps = true
        -- vim.g.no_rust_maps = true
        -- vim.g.no_go_maps = true
      end,
      config = function()
        require('nvim-treesitter-textobjects').setup {
          select = {
            enable = true,
            lookahead = true,
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = false,
          },
          move = {
            enable = true,
            set_jumps = true,
          },
        }

        -- SELECT keymaps
        local sel = require 'nvim-treesitter-textobjects.select'
        for _, map in ipairs {
          { { 'x', 'o' }, 'af', '@function.outer' },
          { { 'x', 'o' }, 'if', '@function.inner' },
          { { 'x', 'o' }, 'ac', '@class.outer' },
          { { 'x', 'o' }, 'ic', '@class.inner' },
          { { 'x', 'o' }, 'aa', '@parameter.outer' },
          { { 'x', 'o' }, 'ia', '@parameter.inner' },
          { { 'x', 'o' }, 'ad', '@comment.outer' },
          { { 'x', 'o' }, 'as', '@statement.outer' },
        } do
          vim.keymap.set(map[1], map[2], function() sel.select_textobject(map[3], 'textobjects') end, { desc = 'Select ' .. map[3] })
        end

        -- MOVE keymaps
        local mv = require 'nvim-treesitter-textobjects.move'
        for _, map in ipairs {
          { { 'n', 'x', 'o' }, ']m', mv.goto_next_start, '@function.outer' },
          { { 'n', 'x', 'o' }, '[m', mv.goto_previous_start, '@function.outer' },
          { { 'n', 'x', 'o' }, ']]', mv.goto_next_start, '@class.outer' },
          { { 'n', 'x', 'o' }, '[[', mv.goto_previous_start, '@class.outer' },
          { { 'n', 'x', 'o' }, ']M', mv.goto_next_end, '@function.outer' },
          { { 'n', 'x', 'o' }, '[M', mv.goto_previous_end, '@function.outer' },
          { { 'n', 'x', 'o' }, ']o', mv.goto_next_start, { '@loop.inner', '@loop.outer' } },
          { { 'n', 'x', 'o' }, '[o', mv.goto_previous_start, { '@loop.inner', '@loop.outer' } },
        } do
          local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
          -- build a human-readable desc
          local qstr = (type(query) == 'table') and table.concat(query, ',') or query
          vim.keymap.set(modes, lhs, function() fn(query, 'textobjects') end, { desc = 'Move to ' .. qstr })
        end

        -- SWAP keymaps
        vim.keymap.set(
          'n',
          '<leader>a',
          function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end,
          { desc = 'Swap next parameter' }
        )
        vim.keymap.set(
          'n',
          '<leader>A',
          function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.outer' end,
          { desc = 'Swap previous parameter' }
        )
      end,
    },
  }
