-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation (no plugin needed)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Buffers
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
vim.keymap.set('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

-- Quickfix / location list (replaces trouble)
vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Prev quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })
vim.keymap.set('n', '<leader>qq', '<cmd>copen<cr>', { desc = 'Open quickfix list' })
vim.keymap.set('n', '<leader>ql', '<cmd>lopen<cr>', { desc = 'Open location list' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Files
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- LSP
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Docs' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })

-- Test runner (nvim-local script)
local function run_test(mode)
  local file = vim.fn.expand('%:p')
  local line = vim.fn.line('.')
  local ft = vim.bo.filetype

  if mode == 'all' then
    local cmd
    if ft == 'go' then
      cmd = 'go test ./...'
    elseif ft == 'rust' then
      cmd = 'cargo nextest run'
    elseif ft == 'java' then
      cmd = 'mvn test'
    elseif ft == 'javascript' or ft == 'typescript' or ft == 'typescriptreact' then
      cmd = 'npx vitest run'
    else
      cmd = 'echo "No test runner for ' .. ft .. '"'
    end
    vim.fn.system('tmux send-keys -t .1 ' .. vim.fn.shellescape(cmd) .. ' Enter')
    return
  end

  vim.fn.system(string.format(
    '%s %s %d %s',
    vim.fn.expand('~/.config/nvim/bin/nvim-test.sh'),
    vim.fn.shellescape(file),
    line,
    mode
  ))
end

vim.keymap.set('n', '<leader>ts', function() run_test('cursor') end, { desc = 'Test: nearest subtest' })
vim.keymap.set('n', '<leader>tt', function() run_test('func') end, { desc = 'Test: function' })
vim.keymap.set('n', '<leader>tf', function() run_test('file') end, { desc = 'Test: file' })
vim.keymap.set('n', '<leader>ta', function() run_test('all') end, { desc = 'Test: all' })

-- Tmux runner (build/run current filetype)
vim.keymap.set('n', '<leader>tr', function()
  local ft = vim.bo.filetype
  vim.fn.system(vim.fn.expand('~/.config/nvim/bin/tmux-runner.sh') .. ' ' .. ft)
end, { desc = 'Tmux run' })

-- Tmux side panes
vim.keymap.set('n', '<leader>gg', function()
  local root = vim.trim(vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'))
  if root == '' then root = vim.fn.expand('%:p:h') end
  vim.fn.system('tmux split-window -h -l 40% -c ' .. vim.fn.shellescape(root) .. ' lazygit')
end, { desc = 'Lazygit pane' })

vim.keymap.set('n', '<leader>fy', function()
  local dir = vim.fn.expand('%:p:h')
  vim.fn.system('tmux split-window -h -l 40% -c ' .. vim.fn.shellescape(dir) .. ' yazi')
end, { desc = 'Yazi pane' })

-- UI toggles
vim.keymap.set('n', '<leader>uw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = 'Toggle wrap' })

vim.keymap.set('n', '<leader>ud', function()
  local vt = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not vt })
end, { desc = 'Toggle diagnostic virtual_text' })

vim.keymap.set('n', '<leader>uc', function()
  vim.o.colorcolumn = vim.o.colorcolumn == '' and '80,120' or ''
end, { desc = 'Toggle colorcolumn' })

vim.keymap.set('n', '<leader>uG', function()
  require('copilot.suggestion').toggle_auto_trigger()
end, { desc = 'Toggle Copilot ghost text' })

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = 'Disable autoformat-on-save', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })
