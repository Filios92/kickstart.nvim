require 'custom.options'

require 'custom.keymaps'
require 'custom.autocmds'
-- require 'custom.diagnostics'

local function set_normal_float_highlight() vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' }) end
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({

  require 'custom.colorschemes',
  require 'custom.plugins.treesitter',

  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- require 'custom.plugins.telescope',
  require 'custom.plugins.which-key',
  require 'custom.plugins.snacks',
  require 'custom.plugins.lsp',
  require 'custom.plugins.dap',

  { 'github/copilot.vim', cond = not vim.g.vscode },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      window = {
        --   layout = 'float',
        --   width = 80, -- Fixed width in columns
        --   height = 20, -- Fixed height in rows
        --   border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        --   title = '🤖 AI Assistant',
        --   zindex = 100, -- Ensure window stays on top
      },
      -- highlight_headers = false,
      separator = '━━',
      error_header = '> [!ERROR] Error',
      headers = {
        user = '- 👤 You',
        assistant = '- 🤖 Copilot',
        tool = '- 🔧 Tool',
      },
      auto_fold = true,
      -- auto_insert_mode = true,
    },
    keys = {
      { '<leader>zc', ':CopilotChat<CR>', mode = 'n', desc = 'Chat with Copilot' },
      { '<leader>ze', ':CopilotChatExplain<CR>', mode = 'v', desc = 'Explain Code' },
      { '<leader>zr', ':CopilotChatReview<CR>', mode = 'v', desc = 'Review Code' },
      { '<leader>zf', ':CopilotChatFix<CR>', mode = 'v', desc = 'Fix Code Issues' },
      { '<leader>zo', ':CopilotChatOptimize<CR>', mode = 'v', desc = 'Optimize Code' },
      { '<leader>zd', ':CopilotChatDocs<CR>', mode = 'v', desc = 'Generate Docs' },
      { '<leader>zt', ':CopilotChatTests<CR>', mode = 'v', desc = 'Generate Tests' },
      { '<leader>zm', ':CopilotChatCommit<CR>', mode = { 'n', 'v' }, desc = 'Generate Commit Message' },
    },
  },

  {
    'olimorris/codecompanion.nvim',
    cond = not vim.g.vscode,
    version = '^19.0.0',
    opts = {
      interactions = {
        chat = {
          adapter = {
            name = 'copilot',
            model = 'gpt-5.1-codex',
          },
        },
      },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
      'nvim-treesitter/nvim-treesitter',
    },
  },

  { 'NMAC427/guess-indent.nvim', cond = not vim.g.vscode, opts = {} },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      if not vim.g.vscode then
        require('mini.sessions').setup {
          autoread = true,
          force = { write = false },
          verbose = { read = true },
          hooks = {
            post = {
              read = function(session)
                if Dart then Dart.read_session(session['name']) end
              end,
              write = function(session)
                if Dart then Dart.write_session(session['name']) end
              end,
            },
          },
        }
        vim.keymap.set('n', '<leader>qs', function()
          local name = vim.fn.input 'Session name'
          require('mini.sessions').write(name)
        end, { desc = 'Save session' })
        vim.keymap.set('n', '<leader>qr', require('mini.sessions').select, { desc = 'Restore session' })

        require('mini.tabline').setup()
        require('mini.pairs').setup()

        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        local get_formatter = function()
          local formatters, will_lsp = require('conform').list_formatters_to_run(vim.api.nvim_get_current_buf())
          local s = ''
          if formatters and #formatters > 0 then
            s = s .. ' 󰷈 '
            for _, formatter in ipairs(formatters) do
              s = s .. formatter.name
            end
          end

          local lsps = require('conform.lsp_format').get_format_clients { bufnr = vim.api.nvim_get_current_buf() }
          if not vim.tbl_isempty(lsps) then
            s = s .. ' 󰷈 LSP '
            for _, sss in ipairs(lsps) do
              s = s .. sss.name
            end
          end

          return s
        end

        -- local sf = MiniStatusline.section_fileinfo
        -- statusline.section_fileinfo = function() return sf { trunc_width = 120 } .. get_formatter() end

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function() return '%2l:%-2v' end
        local sd = MiniStatusline.section_diagnostics
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_diagnostics = function()
          return sd {
            trunc_width = 75,
            signs = {
              ERROR = '󰅚 ',
              WARN = '󰀪 ',
              INFO = '󰋽 ',
              HINT = '󰌶 ',
            },
          }
        end
      end
    end,
  },

  {
    'iofq/dart.nvim',
    enabled = false,
    cond = not vim.g.vscode,
    dependencies = {
      'echasnovski/mini.nvim', -- optional, icons provider
      'nvim-tree/nvim-web-devicons', -- optional, icons provider
    },
    opts = {
      mappings = {
        next = '<C-PageDown>',
        prev = '<C-PageUp>',
      },
    }, -- see Configuration section
  },

  {
    'folke/flash.nvim',
    -- enabled = false,
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = { search = { enabled = false } },
    },
    keys = {
      { '<leader>fs', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { '<leader>fS', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { '<leader>fe', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { '<leader>fE', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },

  {
    'MagicDuck/grug-far.nvim',
    cond = not vim.g.vscode,
    -- opts = {},
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }

      vim.keymap.set({ 'n', 'v', 'x' }, '<leader>sr', function()
        local grug = require 'grug-far'
        local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
        grug.open {
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        }
      end, { desc = 'Search and Replace' })
    end,
  },

  {
    'folke/noice.nvim',
    -- enabled = false,
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    opts = {
      -- add any options here
      cmdline = {
        view = 'cmdline_popup',
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      messages = {
        view_search = 'cmdline',
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
            },
          },
          view = 'notify',
        },
      },

      -- you can enable a preset for easier configuration
      presets = {
        -- bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- 'rcarriga/nvim-notify',
    },
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'copilot-chat', 'codecompanion' },
      code = {
        border = 'thin',
        inline = false,
      },
      heading = {
        width = 'full',
        border = true,
        right_pad = 1,
      },
    },
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  { -- vscode multi cursor
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = not not vim.g.vscode,
    opts = {
      default_mappings = true,
      no_selection = true,
    },
  },
  { -- tmux navigator
    'christoomey/vim-tmux-navigator',
    cond = not vim.g.vscode,
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    border = 'single',
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
