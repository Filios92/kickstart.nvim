local function dap_for_c()
  local ok, dap = pcall(require, 'dap')
  if not ok then return end

  local dap_utils = require 'dap.utils'

  local cwd = vim.fn.getcwd()
  local is_samba = cwd:find 'samba'

  local path = cwd
  if is_samba then path = vim.fs.joinpath(cwd, 'bin') end

  local exec_opts = {
    path = path,
    executables = true,

    filter = function(exec)
      -- Filter out shared libraries
      return not exec:match '%.so([.0-9]*)'
    end,
  }

  --
  -- See
  -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Interpreters.html
  -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Debugger-Adapter-Protocol.html
  dap.adapters.gdb = {
    id = 'gdb',
    type = 'executable',
    command = 'gdb',
    args = { '--quiet', '--interpreter=dap' },
    --[[
    args = {
        '-iex',
        'set debug dap-log-file /tmp/gdb-dap.log',
        '--quiet',
        '--interpreter=dap',
    },
]]
  }

  dap.configurations.c = {
    {
      name = 'Run executable (GDB)',
      type = 'gdb',
      request = 'launch',
      -- This requires special handling of 'run_last', see
      -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
      program = function() return dap_utils.pick_file(exec_opts) end,
    },
    {
      name = 'Run executable with arguments (GDB)',
      type = 'gdb',
      request = 'launch',
      -- This requires special handling of 'run_last', see
      -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
      program = function() return dap_utils.pick_file(exec_opts) end,
      args = function()
        local args_str = vim.fn.input {
          prompt = 'Executable arguments: ',
        }
        return vim.split(args_str, ' +')
      end,
    },
    {
      name = 'Attach to process (GDB)',
      type = 'gdb',
      request = 'attach',
      processId = require('dap.utils').pick_process,
    },
  }

  dap.configurations.cpp = dap.configurations.c
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
  },
  ft = { 'c', 'cpp' },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dapvt = require 'nvim-dap-virtual-text'

    dapui.setup {
      -- icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      -- controls = {
      --   icons = {
      --     pause = '⏸',
      --     play = '▶',
      --     step_into = '⏎',
      --     step_over = '⏭',
      --     step_out = '⏮',
      --     step_back = 'b',
      --     run_last = '▶▶',
      --     terminate = '⏹',
      --     disconnect = '⏏',
      --   },
      -- },
    }

    dapvt.setup()
    vim.fn.sign_define('DapBreakpoint', { text = '🔴' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '🟡' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '⭕' })
    vim.fn.sign_define('DapStopped', {
      text = '󰫎',
      texthl = 'DapStoppedText',
      linehl = 'DapStoppedLine',
      numhl = '',
    })

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end

    -- Auto-open/close UI
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open {} end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close {} end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close {} end
    dap.listeners.before.disconnect['dapui_config'] = function() dapui.close {} end

    dap_for_c()

    -- Virtual text
    require('nvim-dap-virtual-text').setup()

    -- Keymaps
    vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      require('dap').list_breakpoints()
      vim.cmd 'copen'
    end, { desc = 'List Breakpoints' })
    vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Run/Continue' })
    vim.keymap.set('n', '<leader>dC', function() require('dap').run_to_cursor() end, { desc = 'Run to Cursor' })
    vim.keymap.set('n', '<leader>dg', function() require('dap').goto_() end, { desc = 'Go to Line (No Execute)' })
    vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step Into' })
    vim.keymap.set('n', '<leader>dj', function() require('dap').down() end, { desc = 'Down' })
    vim.keymap.set('n', '<leader>dk', function() require('dap').up() end, { desc = 'Up' })
    vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run Last' })
    vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { desc = 'Step Out' })
    vim.keymap.set('n', '<leader>dO', function() require('dap').step_over() end, { desc = 'Step Over' })
    vim.keymap.set('n', '<leader>dP', function() require('dap').pause() end, { desc = 'Pause' })
    vim.keymap.set('n', '<leader>dr', function() require('dap').repl.toggle() end, { desc = 'Toggle REPL' })
    vim.keymap.set('n', '<leader>ds', function() require('dap').session() end, { desc = 'Session' })
    vim.keymap.set('n', '<leader>dt', function()
      require('dap').terminate()
      vim.defer_fn(function() require('dapui').close {} end, 100)
    end, { desc = 'Terminate' })
    vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'DAP Widgets' })
    vim.keymap.set('n', '<leader>du', function() require('dapui').toggle {} end, { desc = 'Dap UI' })
  end,
}
