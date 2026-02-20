return { -- folke/snacks
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  cond = not vim.g.vscode,

  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true, animate = { enabled = false } },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    -- scroll = { enabled = true, animate = { easing = 'outQuint' } },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,

      layout = { preset = 'ivy' },

      formatters = {
        file = {
          filename_first = true,
          -- filename_only = true,
        },
      },

      win = {
        input = {
          keys = {
            ['<PageDown>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<PageUp>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          },
        },
      },
    },
  },

  dependencies = {
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  keys = {
    -- { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    -- { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    -- { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },

    -- Top Pickers & Explorer
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },

    -- find
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },

    -- git
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
    { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
    { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
    { '<leader>gD', function() Snacks.picker.git_diff { base = 'origin' } end, desc = 'Git Diff (origin)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },

    -- Grep
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },

    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
    { '<leader>sf', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help' },
    { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
    { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
    { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
    { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },

    -- todo
    { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Todo' },
    { '<leader>sT', function() Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } } end, desc = 'Todo/Fix/Fixme' },

    -- LSP
    -- look at LSPAttch

    -- buffers
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete buffer', mode = { 'n' } },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete other buffers', mode = { 'n' } },

    -- terminal
    { '<leader>fT', function() Snacks.terminal() end, desc = 'Terminal (cwd)', mode = 'n' },
    { '<leader>ft', function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = 'Terminal (Root Dir)', mode = 'n' },
    -- { '<C-:>', function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = 'Terminal (Root Dir)', mode = 'n' },
    { '<C-;>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    { '<F20>', function() Snacks.terminal() end, desc = 'which_key_ignore' },
    -- { '<c-_>', function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = 'which_key_ignore', mode = 'n' },

    -- -- Other
    -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    -- { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    -- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    -- { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    -- { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    -- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    -- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
}
