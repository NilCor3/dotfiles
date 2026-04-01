---@module 'snacks'
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        fullscreen = true,
        cycle = true,
        preset = function()
          return vim.o.columns >= 220 and 'default' or 'vertical'
        end,
      },
      sources = {
        explorer = { enabled = true, layout = { fullscreen = false } },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  -- stylua: ignore
  keys = {
    -- Top Pickers & Explorer
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files', },
    { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers', },
    { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History', },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer', },
    -- find (Helix Space+f/b/r/g/p aligned)
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File', },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files', },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files', },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects', },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent', },
    -- Helix Space+d/D diagnostics
    { '<leader>fd', function() Snacks.picker.diagnostics() end, desc = 'Workspace Diagnostics', },
    { '<leader>fD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics', },
    -- Helix Space+? keymaps / command palette
    { '<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
    -- Global search (Helix Space+/)
    { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep', },
    -- git
    { '<leader>gB', function() Snacks.git.blame_line() end, desc = 'Git Blame Line' },
    { '<leader>gl', function() Snacks.picker.git_log_file() end, desc = 'Git Log (File)' },
    -- Grep
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' }, },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers', },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History', },
    { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
    { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History', },
    { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands', },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages', },
    { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights', },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons', },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps', },
    { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List', },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks', },
    { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages', },
    { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec', },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List', },
    { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume', },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History', },
    { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes', },
    -- LSP
    { '<leader>gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition', },
    { '<leader>gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration', },
    { '<leader>gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References', },
    { '<leader>gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation', },
    { '<leader>gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition', },
    { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols', },
    { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', },
    -- Helix Space+s/S symbol pickers
    { '<leader>fs', function() Snacks.picker.lsp_symbols() end, desc = 'Document Symbols', },
    { '<leader>fS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Workspace Symbols', },
    -- Other
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
    { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer', },
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification History', },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications', },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' }, },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' }, },
  },
}
