return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  cond = not vim.g.vscode,
  event = 'VimEnter',
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    preset = 'helix',
    win = { no_overlap = false },

    -- Document existing key chains
    spec = {
      { '<leader>c', group = 'Code', mode = { 'n', 'v' } },
      -- { '<leader>D', group = 'Diffview', icon = { icon = '', color = 'orange' } },
      { '<leader>f', group = 'Find', mode = { 'n', 'v' } },
      { '<leader>g', group = 'Git', icon = { icon = '' } },
      -- { '<leader>p', group = 'Yanky', icon = { icon = '󰃮 ', color = 'yellow' } },
      { '<leader>s', group = 'Search', mode = { 'n', 'v' } },
      { '<leader>t', group = 'Toggle' },
      { '<leader>h', group = 'Git Hunk', mode = { 'n', 'v' } },
      { '<leader><tab>', group = 'Tabs' },
      { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
      { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
      { '<leader>q', group = 'Quit' },
      {
        '<leader>b',
        group = 'Buffer',
        expand = function() return require('which-key.extras').expand.buf() end,
      },
      {
        '<leader>w',
        group = 'windows',
        proxy = '<c-w>',
        expand = function() return require('which-key.extras').expand.win() end,
      },
      {
        '<leader>fC',
        group = 'Copy Path',
        {
          '<leader>fCf',
          function()
            vim.fn.setreg('+', vim.fn.expand '%:p') -- Copy full file path to clipboard
            vim.notify('Copied full file path: ' .. vim.fn.expand '%:p')
          end,
          desc = 'Copy full file path',
        },
        {
          '<leader>fCn',
          function()
            vim.fn.setreg('+', vim.fn.expand '%:t') -- Copy file name to clipboard
            vim.notify('Copied file name: ' .. vim.fn.expand '%:t')
          end,
          desc = 'Copy file name',
        },
        {
          '<leader>fCr',
          function()
            local cwd = vim.fn.getcwd() -- Current working directory
            local full_path = vim.fn.expand '%:p' -- Full file path
            local rel_path = full_path:sub(#cwd + 2) -- Remove cwd prefix and leading slash
            vim.fn.setreg('+', rel_path) -- Copy relative file path to clipboard
            vim.notify('Copied relative file path: ' .. rel_path)
          end,
          desc = 'Copy relative file path',
        },
        {
          '<leader>?',
          function() require('which-key').show { global = false } end,
          desc = 'Buffer Keymaps (which-key)',
        },
        {
          '<c-w><space>',
          function() require('which-key').show { keys = '<c-w>', loop = true } end,
          desc = 'Window Hydra Mode (which-key)',
        },
      },
    },
    triggers = {
      -- { '<auto>', mode = 'nixsotc' },
      { '<auto>', mode = 'nxso' },
      { 's', mode = { 'n', 'v' } },
    },
  },
}
