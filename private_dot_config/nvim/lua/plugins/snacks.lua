---@module 'snacks'
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
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
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= 220 and 'default' or 'vertical'
        end,
      },
      sources = {
        explorer = { enabled = true, layout = { fullscreen = false } },
      },
      -- layouts = {
      --   vertical = {
      --     layout = {
      --       box = 'vertical',
      --       { win = 'input', border = 'rounded', height = 1 },
      --       { win = 'list', border = 'rounded' },
      --       { win = 'preview', border = 'rounded' },
      --     },
      --   },
      -- },
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
    -- find
    -- { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File', },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files', },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files', },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects', },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent', },
    -- git
    -- { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches', },
    -- { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log', },
    -- { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line', },
    -- { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status', },
    -- { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash', },
    -- { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)', },
    -- { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File', },
    -- { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' }, },
    -- { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit', },
    -- Grep
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep', },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' }, },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers', },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History', },
    { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
    { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History', },
    { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands', },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics', },
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics', },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages', },
    { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights', },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons', },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps', },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
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
    -- Other
    -- { '<leader>z', function() Snacks.zen() end, desc = 'Toggle Zen Mode', },
    -- { '<leader>Z', function() Snacks.zen.zoom() end, desc = 'Toggle Zoom', },
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
    { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer', },
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification History', },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications', },
    -- { '<c-/>', function() Snacks.terminal() end, desc = 'Toggle Terminal', },
    -- { '<c-_>', function() Snacks.terminal() end, desc = 'which_key_ignore', },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' }, },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' }, },
    {
      -- Add the keymap to show the popup with a full line of text
      '<leader>l',
      function()
        local current_line = vim.api.nvim_get_current_line() -- Get the current line of text
        local current_buf = vim.api.nvim_get_current_buf()   -- Get the current buffer
        local current_ft = vim.bo[current_buf].filetype      -- Get the filetype of the current buffer

        local popup = Snacks.win({
          text = current_line, -- Use the current line of text
          position = 'float',
          width = 0.8,         -- Adjust width to display the full line comfortably
          height = 0.1,        -- Small height for a single line of text
          backdrop = 60,       -- Optional: Set the backdrop opacity
          border = 'rounded',  -- Optional: Apply rounded border for aesthetics
          minimal = true,      -- Minimal window with no extra UI elements
          wo = {
            spell = false,
            wrap = true,
            linebreak = true,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
          bo = {
            filetype = current_ft, -- Set the filetype for syntax highlighting
            buftype = 'nofile',    -- Set the buffer type to nofile
            swapfile = false,      -- Disable swap file
            bufhidden = 'wipe',    -- Wipe the buffer when hidden
          },
        })

        -- Set keybinding after creating window
        popup:map('n', 'q', function()
          popup:close()
        end)

        popup:show()

        -- After the popup is shown, apply window-local settings
        -- vim.schedule(function()
        --   local winid = popup.win
        --     print('Window ID:', winid) -- Print the window ID for debugging
        --   if winid and vim.api.nvim_win_is_valid(winid) then
        --     print('Window ID:', winid) -- Print the window ID for debugging
        --     vim.api.nvim_win_set_option(winid, 'wrap', true)
        --     vim.api.nvim_win_set_option(winid, 'cursorline', true)
        --     vim.api.nvim_win_set_option(winid, 'whichwrap', 'b,s,<,>,[,],h,l,j,k') -- or just 'j,k' if you prefer
        --   end
        -- end)
      end,
      desc = 'Show Full Line Popup', -- Description for the keymap
    },
  },
}
