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
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
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
    'nvim-treesitter/nvim-treesitter',
    cond = not vim.g.vscode,
    -- build = ':TSUpdate',
    -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    config = function()
      local filetypes = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
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
  }
