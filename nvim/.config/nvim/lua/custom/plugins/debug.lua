-- Debugger (nvim-dap) with a UI. Language adapters register themselves:
-- C# adapters come from easy-dotnet.nvim (see dotnet.lua).

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle [B]reakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Conditional [B]reakpoint' },
    { '<leader>Dc', function() require('dap').run_to_cursor() end, desc = 'Run to [C]ursor' },
    { '<leader>Dr', function() require('dap').repl.toggle() end, desc = 'Toggle [R]EPL' },
    { '<leader>De', function() require('dapui').eval() end, desc = '[E]valuate expression', mode = { 'n', 'v' } },
    { '<leader>Dx', function() require('dap').clear_breakpoints() end, desc = 'Clear all breakpoints' },
    { '<leader>Dq', function() require('dap').terminate() end, desc = '[Q]uit debug session' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
