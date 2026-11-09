-- C# / .NET: easy-dotnet.nvim gives the Roslyn LSP, run/build/test/debug,
-- a Rider-style test runner, NuGet, user-secrets and EF Core commands.
--
-- Needs these global dotnet tools (on PATH via ~/.dotnet/tools):
--   dotnet tool install -g EasyDotnet
--   dotnet tool install -g roslyn-language-server --prerelease
--   dotnet tool install -g dotnet-ef
-- Check with :checkhealth easy-dotnet

-- easy-dotnet ignores `launchBrowser` in launchSettings.json, so emulate it:
-- collect the URL of every profile with launchBrowser = true under the cwd,
-- poll those URLs and open the first one that answers in the browser.
local function browser_urls()
  local urls = {}
  local files = vim.fs.find('launchSettings.json', { path = vim.fn.getcwd(), type = 'file', limit = math.huge })
  for _, file in ipairs(files) do
    if not file:match '/bin/' and not file:match '/obj/' then
      local text = table.concat(vim.fn.readfile(file), '\n'):gsub('^\239\187\191', '') -- strip the UTF-8 BOM
      local ok, settings = pcall(vim.json.decode, text)
      for _, profile in pairs(ok and settings.profiles or {}) do
        if profile.launchBrowser and profile.applicationUrl then
          -- Prefer the http URL: https needs a trusted dev certificate.
          local base = profile.applicationUrl:match 'http://[^;]+' or profile.applicationUrl:match '[^;]+'
          local url = base:gsub('/$', '') .. '/' .. (profile.launchUrl or '')
          if not vim.tbl_contains(urls, url) then table.insert(urls, url) end
        end
      end
    end
  end
  return urls
end

local function open_browser_when_ready()
  local urls = browser_urls()
  if #urls == 0 then return end

  local timer = vim.uv.new_timer()
  local deadline = vim.uv.now() + 300000 -- give the build and startup 5 minutes
  local opened = false
  timer:start(3000, 1000, function()
    if opened then return end
    if vim.uv.now() > deadline then
      timer:stop()
      timer:close()
      return
    end
    for _, url in ipairs(urls) do
      vim.system({ 'curl', '-s', '-o', '/dev/null', '-m', '1', '-w', '%{http_code}', url }, { text = true }, function(res)
        if opened or res.stdout == nil or res.stdout == '000' then return end
        opened = true
        vim.schedule(function()
          if not timer:is_closing() then
            timer:stop()
            timer:close()
          end
          vim.ui.open(url)
          vim.notify('Opened ' .. url)
        end)
      end)
    end
  end)
end

---@module 'lazy'
---@type LazySpec
return {
  'GustavEikaas/easy-dotnet.nvim',
  ft = { 'cs', 'razor' },
  cmd = 'Dotnet',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'mfussenegger/nvim-dap',
  },
  keys = {
    { '<leader>nb', '<cmd>Dotnet build quickfix<cr>', desc = '[B]uild project' },
    { '<leader>nB', '<cmd>Dotnet build solution quickfix<cr>', desc = '[B]uild solution' },
    {
      '<leader>nr',
      function()
        vim.cmd 'Dotnet run profile'
        open_browser_when_ready()
      end,
      desc = '[R]un (pick launch profile, opens browser)',
    },
    { '<leader>nw', '<cmd>Dotnet watch<cr>', desc = '[W]atch' },
    {
      '<leader>nD',
      function()
        vim.cmd 'Dotnet debug profile'
        open_browser_when_ready()
      end,
      desc = '[D]ebug (pick launch profile, opens browser)',
    },
    { '<leader>nu', '<cmd>Dotnet testrunner<cr>', desc = 'Test r[u]nner' },
    { '<leader>ns', '<cmd>Dotnet secrets<cr>', desc = 'User [S]ecrets' },
    { '<leader>na', '<cmd>Dotnet add package<cr>', desc = '[A]dd NuGet package' },
    { '<leader>no', '<cmd>Dotnet outdated<cr>', desc = '[O]utdated packages' },
    { '<leader>nR', '<cmd>Dotnet restore<cr>', desc = '[R]estore' },
    { '<leader>nc', '<cmd>Dotnet clean<cr>', desc = '[C]lean' },
    { '<leader>nx', '<cmd>Dotnet terminal toggle<cr>', desc = 'Toggle .NET terminal' },
    { '<leader>nem', '<cmd>Dotnet ef migrations add<cr>', desc = 'EF: add [M]igration' },
    { '<leader>nel', '<cmd>Dotnet ef migrations list<cr>', desc = 'EF: [L]ist migrations' },
    { '<leader>neu', '<cmd>Dotnet ef database update<cr>', desc = 'EF: database [U]pdate' },
  },
  config = function()
    require('easy-dotnet').setup {
      picker = 'telescope',
      debugger = {
        -- Bundled osx-arm64 build. Switch to 'sharpdbg' if netcoredbg misbehaves.
        engine = 'netcoredbg',
        console = 'integratedTerminal',
      },
      test_runner = {
        viewmode = 'float',
        -- Move the in-buffer test keys under <leader>n so they don't clash with
        -- kickstart's <leader>t (toggle) group or the <leader>D debug group.
        mappings = {
          run_test_from_buffer = { lhs = '<leader>nt', desc = 'run test from buffer' },
          run_all_tests_from_buffer = { lhs = '<leader>nT', desc = 'run all tests in file' },
          debug_test_from_buffer = { lhs = '<leader>nd', desc = 'debug test from buffer' },
          peek_stack_trace_from_buffer = { lhs = '<leader>np', desc = 'peek stack trace from buffer' },
        },
      },
      auto_bootstrap_namespace = {
        type = 'block_scoped', -- matches the Pepla .NET code
        enabled = true,
      },
    }
  end,
}
