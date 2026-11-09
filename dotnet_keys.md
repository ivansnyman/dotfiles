# Neovim .NET and debug shortcuts

These keys come from two plugin files in `nvim/.config/nvim/lua/custom/plugins/`:

- `dotnet.lua`: [easy-dotnet.nvim](https://github.com/GustavEikaas/easy-dotnet.nvim) (Roslyn LSP, build, run, test, NuGet, EF Core)
- `debug.lua`: [nvim-dap](https://github.com/mfussenegger/nvim-dap) with nvim-dap-ui and nvim-dap-virtual-text

The leader key is `<Space>`. Press `<Space>n` or `<Space>D` and wait, and which-key lists the keys in that group.

## .NET commands (`<leader>n`)

Each of these keys loads easy-dotnet if it is not loaded yet. When there is more than one project or launch profile, a Telescope picker opens.

| Key | Command | What it does |
|---|---|---|
| `<leader>nb` | `Dotnet build quickfix` | Builds a project. Build errors go to the quickfix list (`:copen`, then `]q` and `[q` to step through them). |
| `<leader>nB` | `Dotnet build solution quickfix` | Builds the whole solution. Errors go to the quickfix list. |
| `<leader>nr` | `Dotnet run profile` | Picks a project and a profile from `Properties/launchSettings.json`, then runs it. The profile sets `ASPNETCORE_ENVIRONMENT` or `DOTNET_ENVIRONMENT` and the URLs. For profiles with `launchBrowser: true`, the browser opens on `launchUrl` (for the API, `http://localhost:5164/swagger`) as soon as the app answers. |
| `<leader>nw` | `Dotnet watch` | Runs a project with `dotnet watch`, which rebuilds and restarts on file changes. |
| `<leader>nD` | `Dotnet debug profile` | Picks a project and a launch profile, then starts it under the debugger (netcoredbg). Set breakpoints first. Opens the browser the same way as `<leader>nr`. |
| `<leader>nu` | `Dotnet testrunner` | Opens the Rider-style test runner window. See [Test runner window](#test-runner-window). |
| `<leader>ns` | `Dotnet secrets` | Picks a project and opens its `dotnet user-secrets` `secrets.json` for editing. |
| `<leader>na` | `Dotnet add package` | Searches NuGet and adds a package to a project. |
| `<leader>no` | `Dotnet outdated` | Run this in a `.csproj` or `Directory.Build.props` buffer. It shows the latest version of each package as virtual text and adds the two upgrade keys below to that buffer. |
| `<leader>pu` | (after `<leader>no`) | Upgrades the package under the cursor to the latest version. |
| `<leader>pa` | (after `<leader>no`) | Upgrades all outdated packages in the buffer. |
| `<leader>nR` | `Dotnet restore` | Runs `dotnet restore`. |
| `<leader>nc` | `Dotnet clean` | Runs `dotnet clean`. |
| `<leader>nx` | `Dotnet terminal toggle` | Shows or hides the terminal panel where run, watch and build output appears. |

### EF Core (`<leader>ne`)

These commands need `dotnet-ef`, which is installed as a global tool. They fill in `--project` and `--startup-project` for you.

| Key | Command | What it does |
|---|---|---|
| `<leader>nem` | `Dotnet ef migrations add` | Asks for a name and adds a migration. |
| `<leader>nel` | `Dotnet ef migrations list` | Lists the migrations and shows which ones are applied. |
| `<leader>neu` | `Dotnet ef database update` | Applies pending migrations to the database in the connection string. Check which database that is first: the dev DB is shared. |

### Test keys inside a test file

These keys work only in a buffer that contains tests. Test methods show pass and fail signs in the gutter.

| Key | What it does |
|---|---|
| `<leader>nt` | Runs the test under the cursor. |
| `<leader>nT` | Runs all tests in the file. |
| `<leader>nd` | Debugs the test under the cursor. Set breakpoints first. |
| `<leader>np` | Shows the stack trace of the failed test under the cursor. |

## Test runner window

Open the window with `<leader>nu`. These keys work only inside it. They are the easy-dotnet defaults.

| Key | What it does |
|---|---|
| `o` | Expands or collapses the node under the cursor. |
| `E` | Expands all nodes. |
| `W` | Collapses all nodes. |
| `<leader>r` | Runs the node under the cursor (solution, project, namespace, class or test). |
| `<leader>R` | Runs all tests. |
| `<leader>d` | Debugs the node under the cursor. |
| `<leader>p` | Shows the stack trace of a failed test. |
| `<leader>g` | Opens the file for the test under the cursor. |
| `<leader>e` | Shows build errors after a failed build. |
| `]f` / `[f` | Jumps to the next or previous failed test. `.` repeats the jump. |
| `<C-r>` | Refreshes the node (discovers tests again). |
| `<C-c>` | Cancels the run or build in progress. |
| `q` | Closes the window. |

## Debugging

### Function keys

On a MacBook, hold `fn` with these keys unless the function keys are set as standard function keys in System Settings. The config does not use F10 to F12, because macOS takes some of them.

| Key | What it does |
|---|---|
| `F5` | Starts debugging, or continues to the next breakpoint. In a .NET project it asks which project to start. |
| `F1` | Steps into the call on the current line. |
| `F2` | Steps over the current line. |
| `F3` | Steps out of the current function. |
| `F7` | Shows or hides the debug UI (scopes, watches, stack, breakpoints, console). The UI opens when a session starts and closes when it ends. Use `F7` to see the output of the last session. |

### Breakpoints and session (`<leader>b`, `<leader>D`)

| Key | What it does |
|---|---|
| `<leader>b` | Adds or removes a breakpoint on the current line. |
| `<leader>B` | Adds a conditional breakpoint. It asks for a condition, for example `callId == 42`. |
| `<leader>Dc` | Runs to the cursor line, without a breakpoint. |
| `<leader>Dr` | Opens or closes the debug REPL. Expressions run in the current frame, and `x = 5` changes a variable. |
| `<leader>De` | Evaluates the expression under the cursor, or the visual selection, and shows the result in a float. |
| `<leader>Dx` | Removes all breakpoints. |
| `<leader>Dq` | Stops the debug session. |

While a session is paused, variable values show as virtual text at the end of each line.

## LSP keys for C#

C# uses the standard kickstart LSP keys. Roslyn supplies the results.

| Key | What it does |
|---|---|
| `grd` | Goes to the definition. `<C-t>` jumps back. |
| `grr` | Lists references. |
| `gri` | Goes to implementations, for example from an interface to its classes. |
| `grt` | Goes to the type definition. |
| `grn` | Renames the symbol in the whole solution. |
| `gra` | Shows code actions (add a using, implement an interface, generate a method). |
| `gO` | Searches symbols in the file. |
| `gW` | Searches symbols in the workspace. |
| `K` | Shows hover documentation. |
| `<leader>f` | Formats the buffer with the Roslyn formatter. |
| `<leader>th` | Turns inlay hints (parameter names, inferred types) on or off. |

## Other commands

These have no key. Type them as `:` commands.

| Command | What it does |
|---|---|
| `:Dotnet` | Lists all easy-dotnet commands. |
| `:Dotnet solution select` | Selects the `.sln` to use when a folder has more than one. |
| `:Dotnet ef migrations remove` | Removes the last migration. |
| `:Dotnet ef database update pick` | Updates the database to a migration you pick. |
| `:Dotnet new` | Creates a project or file from a `dotnet new` template. |
| `:checkhealth easy-dotnet` | Checks the dotnet tools and dependencies. Open a `.cs` file first so the plugin is loaded. |

## macOS note for Pepla Voice

Start Neovim from a terminal inside `~/work/pepla/voice`. A `chpwd` hook in `zsh/.zshrc` sets `NLog__ConfigurationFileName=nlog.mac.config` only in that folder. Runs and debug sessions started from Neovim inherit these env vars, so the apps log to `~/Logs/PeplaVoice/<App>/`.
