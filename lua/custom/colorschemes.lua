return {
  { -- You can easily change to a different colorscheme.
    'folke/tokyonight.nvim',
    cond = not vim.g.vscode,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = true,
        style = 'night',
        styles = {
          comments = { italic = true },
          sidebars = 'transparent',
          floats = 'transparent',
        },
        dim_inactive = true,
      }

      -- vim.api.nvim_create_autocmd('ColorScheme', {
      --   pattern = '*',
      --   callback = set_normal_float_highlight,
      -- })
      -- vim.api.nvim_create_autocmd('ColorScheme', {
      --   pattern = '*',
      --   callback = function()
      --     vim.api.nvim_set_hl(0, 'SnacksPicker', { bg = 'none', nocombine = true })
      --     vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { fg = '#316c71', bg = 'none', nocombine = true })
      --     vim.api.nvim_set_hl(0, 'SnacksPickerInputBorder', { fg = '#FF9E64', bg = 'none', nocombine = true })
      --     -- set_normal_float_highlight()
      --   end,
      -- })

      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  {
    'catppuccin/nvim',
    cond = not vim.g.vscode,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = 'true',
        auto_integrations = true,
      }
    end,
  },
}
